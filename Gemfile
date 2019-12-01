# frozen_string_literal: true

source 'https://rubygems.org'

gem 'bcrypt'
gem 'erubis'
gem 'fileutils'
gem 'rack'
gem 'sinatra'
gem 'sinatra-contrib'

ruby '2.6.5'

group :production do
  gem 'puma'
end

group :test do
  gem 'coveralls', require: false
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'rack-test'
end

group :development do
  gem 'rake'
  gem 'rubocop'
end

group :test, :development do
  gem 'pry'
end
