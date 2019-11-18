# frozen_string_literal: true

require 'sinatra'
require 'sinatra/content_for'
require 'sinatra/reloader' if development?
require 'tilt/erubis'

get '/' do
  erb :index
end

get '/signin' do
  erb :signin
end

get '/signup' do
  erb :signup
end
