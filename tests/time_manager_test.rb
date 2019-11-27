# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/text'

require_relative '../time_manager'

class TimeManagerTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end
