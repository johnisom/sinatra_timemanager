# frozen_string_literal: true

require 'rack/test'

require_relative '../time_manager'

# Base test class for signed in and signed out tests
class BaseTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def assert_status_and_content_type
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
  end
end
