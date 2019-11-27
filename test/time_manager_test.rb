# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/reporters'
require 'rack/test'

require_relative '../time_manager'
require_relative 'signed_out_assertions'

Minitest::Reporters.use!

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

# Signed out tests
class SignedOutTest < BaseTest
  include SignedOutAssertions

  def test_index
    get '/'

    assert_status_and_content_type
    assert_header
    assert_main_index
  end

  def test_home
    get '/home'

    assert_equal 302, last_response.status

    # Redirect to index
    get last_response['Location']

    assert_status_and_content_type

    # Make sure it redirects to index
    assert_header
    assert_main_index
  end

  def test_help
    get '/help'

    assert_status_and_content_type
    assert_header
    assert_main_help
  end

  def test_about
    get '/about'

    assert_status_and_content_type
    assert_header
    assert_main_about
  end

  def test_sign_in
    get '/sign-in'

    assert_status_and_content_type
    assert_header
    assert_main_sign_in
  end

  def test_sign_up
    get '/sign-up'

    assert_status_and_content_type
    assert_header
    assert_main_sign_up
  end
end