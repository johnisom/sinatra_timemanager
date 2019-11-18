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

get '/' do
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
  flash("You were successfully signed in, #{params[:username]}!", :success)
  session[:username] = params[:username]
  redirect '/'
end

post '/signup' do
  flash("Welcome aboard, #{params[:username]}!", :success)
  session[:username] = params[:username]
  redirect '/'
end

post '/signout' do
  flash("You were successfully signed out.", :success)
  session.delete(:username)
  redirect '/'
end
