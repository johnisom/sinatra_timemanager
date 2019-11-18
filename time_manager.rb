# frozen_string_literal: true

require 'sinatra'
require 'sinatra/content_for'
require 'sinatra/reloader' if development?
require 'tilt/erubis'
require 'bcrypt'

require 'securerandom'
require 'yaml'

configure do
  enable :sessions
  set :session_secret, 'secret'
end

def flash(message, type = :neutral)
  session[:flash] = { message: message, type: type }
end

def credentials
  Psych.load_file('credentials.yml')
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
    "Credentials are invalid. Try again."
  end
end

def error_for_signup(username, password)
  if !(2..16).cover? username.size
    'Username must be between 2 and 16 characters long.'
  elsif !(8..16).cover? password.size
    'Password must be between 8 and 16 characters long.'
  elsif username =~ /\W/
    'Username must only contain alphanumeric characters (0-9, A-z, _).'
  elsif !(password =~ /\d/ && password =~ /[\W\S]/ && password =~ /[a-z]/i)
    'Password must contain at least 1 number, 1 special character, and 1 letter.'
  elsif taken?(username)
    "Sorry, #{username} is already taken."
  end
end

def create_user(username, password)
  new_creds = credentials
  new_creds[username] = BCrypt::Password.create(password).to_s
  File.write('credentials.yml', Psych.dump(new_creds))
end

def check_unauthorization
  if session[:username]
    flash('You must be signed out to do that.', :danger)
    redirect '/'
  end
end

def check_authorization
  unless session[:username]
    flash('You must be signed in to do that.', :danger)
    redirect '/'
  end
end

get '/' do
  erb :index
end

get '/help' do
  erb :help
end

get '/about' do
  erb :about
end

get '/view' do
  erb :view
end

get '/startstopundo' do
  erb :startstopundo
end

get '/signin' do
  check_unauthorization

  erb :signin
end

get '/signup' do
  check_unauthorization

  erb :signup
end

get '/signout' do
  check_authorization

  erb :signout
end

post '/signin' do
  check_unauthorization

  username = params[:username].strip
  password = params[:password]

  if (error = error_for_signin(username, password))
    flash(error, :danger)
    erb :signin
  else
    flash("You were successfully signed in.", :success)
    session[:username] = username
    redirect '/'
  end
end

post '/signup' do
  check_unauthorization

  username = params[:username].strip
  password = params[:password]

  if (error = error_for_signup(username, password))
    flash(error, :danger)
    erb :signup
  else
    create_user(username, password)
    flash("Welcome aboard, #{username}!", :success)
    session[:username] = username
    redirect '/'
  end
end

post '/signout' do
  check_authorization

  flash("You were successfully signed out.", :success)
  session.delete(:username)
  redirect '/'
end
