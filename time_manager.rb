# frozen_string_literal: true

require 'sinatra'
require 'sinatra/content_for'
require 'sinatra/reloader' if development?
require 'tilt/erubis'
require 'bcrypt'
require 'securerandom'
require 'yaml'
require 'pg'

require_relative 'lib/tm'

CURR_PATH = ENV['RACK_ENV'] == 'test' ? 'tmp' : '.'
CREDS_PATH = File.expand_path('credentials', CURR_PATH)
DATA_PATH = File.expand_path('data', CURR_PATH)

configure do
  enable :sessions
  set :session_secret, development? ? 'secret' : SecureRandom.hex(100)
  set :erb, escape_html: true

  FileUtils.mkdir_p(CREDS_PATH) unless File.directory?(CREDS_PATH)
end

def flash(message, type = :neutral)
  session[:flash] = { message: message, type: type }
end

def credentials
  connection = if production?
                 PG.connect(ENV['DATABASE_URL'])
               else
                 PG.connect(dbname: 'time_manager')
               end

  creds = connection.exec(<<~SQL).map do |tup|
      SELECT username, password_hash
        FROM users;
    SQL
    tup.values
  end

  connection.close

  creds.to_h
end

def valid_credentials?(username, password)
  BCrypt::Password.new(credentials[username]) == password
end

def taken?(username)
  credentials.keys.include? username
end

def error_for_signin(username, password)
  if !taken?(username)
    "Sorry, we couldn't find a username matching #{username}."
  elsif !valid_credentials?(username, password)
    'Credentials are invalid. Try again.'
  end
end

def error_for_signup(username, password)
  error_for_username(username) || error_for_password(password)
end

def error_for_username(username)
  if !(2..16).cover? username.size
    'Username must be between 2 and 16 characters long.'
  elsif username =~ /\W/
    'Username must only contain alphanumeric characters (0-9, A-z, _).'
  elsif taken?(username)
    "Sorry, #{username} is already taken."
  end
end

def error_for_password(password)
  if !(8..16).cover? password.size
    'Password must be between 8 and 16 characters long.'
  elsif !(password =~ /\d/ && password =~ /[\W]/ && password =~ /[a-z]/i)
    'Password must contain at least 1 number,'\
    ' 1 special character, and 1 letter.'
  end
end

def create_user(username, password)
  connection = if production?
                 PG.connect(ENV['DATABASE_URL'])
               else
                 PG.connect(dbname: 'time_manager')
               end

  password_hash = BCrypt::Password.create(password).to_s
  connection.exec_params(<<~SQL, [username, password_hash])
    INSERT INTO users (username, password_hash)
    VALUES ($1, $2);
  SQL

  connection.close
end

def check_unauthorization
  return unless session[:username]

  flash('You must be signed out to do that.', :danger)
  redirect '/'
end

def check_authorization
  return if session[:username]

  flash('You must be signed in to do that.', :danger)
  redirect '/'
end

get '/' do
  erb session[:username] ? :signed_in_home : :signed_out_home
end

get '/home' do
  redirect '/'
end

get '/help' do
  erb :help
end

get '/about' do
  erb :about
end

get '/view' do
  check_authorization

  begin
    @content = TM.new(session[:username]).view(params[:timeframe_from],
                                               params[:timeframe_to],
                                               params[:view_option])
    erb :view
  rescue NoViewDataError => e
    flash(e.message, :danger)
    redirect '/actions'
  rescue InvalidFiltersError => e
    flash(e.message, :danger)
    @content = '<div id="shrug">¯\_(ツ)_/¯</div>'
    erb :view
  end
end

get '/actions' do
  check_authorization

  erb :actions
end

get '/undo' do
  check_authorization

  erb :undo
end

get '/sign-in' do
  check_unauthorization

  erb :sign_in
end

get '/sign-up' do
  check_unauthorization

  erb :sign_up
end

get '/sign-out' do
  check_authorization

  erb :sign_out
end

post '/sign-in' do
  check_unauthorization

  username = params[:username].strip
  password = params[:password]

  if (error = error_for_signin(username, password))
    flash(error, :danger)
    erb :sign_in
  else
    flash('You were successfully signed in.', :success)
    session[:username] = username
    redirect '/'
  end
end

post '/sign-up' do
  check_unauthorization

  username = params[:username].strip
  password = params[:password]

  if (error = error_for_signup(username, password))
    flash(error, :danger)
    erb :sign_up
  else
    create_user(username, password)
    flash("Welcome aboard, #{username}!", :success)
    session[:username] = username
    redirect '/'
  end
end

post '/sign-out' do
  check_authorization

  flash('You were successfully signed out.', :success)
  session.delete(:username)
  session.delete(:time_manager)
  redirect '/'
end

post '/start' do
  check_authorization

  message = params[:message] unless params[:message].empty?
  TM.new(session[:username]).start(message: message)
  flash('Time started.')
  redirect '/actions'
rescue StartTwiceError => e
  flash(e.message, :danger)
  erb :actions
end

post '/stop' do
  check_authorization

  message = params[:message] unless params[:message].empty?
  TM.new(session[:username]).stop(message: message)
  flash('Time stopped.')
  redirect '/actions'
rescue StopTwiceError => e
  flash(e.message, :danger)
  erb :actions
end

post '/undo' do
  check_authorization

  TM.new(session[:username]).undo
  flash('Last entry undone.')
  redirect '/actions'
rescue MaxUndoError => e
  flash(e.message, :danger)
  erb :actions
end

not_found do
  flash("That page doesn't exist", :danger)
  redirect '/'
end
