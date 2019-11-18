# frozen_string_literal: true

require 'sinatra'
require 'sinatra/content_for'
require 'sinatra/reloader' if development?
require 'tilt/erubis'
require 'securerandom'

configure do
  enable :sessions
  set :session_secret, 'secret'
end

def flash(message, type = :neutral)
  session[:flash] = { message: message, type: type }
end

before '/' do
  session[:username] = 'johnisom2001'
end

get '/' do
  flash('hello')
  erb :index
end

get '/signin' do
  erb :signin
end

get '/signup' do
  erb :signup
end

get '/signout' do
  erb :signout
end

post '/signin' do
  redirect '/'
end

post '/signup' do
  redirect '/'
end

post '/signout' do
  redirect '/'
end
