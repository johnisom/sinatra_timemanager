# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/reporters'
require 'rack/test'

require_relative '../time_manager'
require_relative 'signed_out_assertions'

Minitest::Reporters.use!

# Main test class for main application
class SignedOutTest < Minitest::Test
  include Rack::Test::Methods

  include SignedOutAssertions

  def app
    Sinatra::Application
  end

  def test_index
    get '/'

    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_header
    assert_main_index
  end

  def test_home
    get '/home'

    assert_equal 302, last_response.status

    # Redirect to index
    get last_response['Location']

    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']

    # Make sure it redirects to index
    assert_header
    assert_main_index
  end

  def test_help
    get '/help'

    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_header
    assert_main_help
  end
end
