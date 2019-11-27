# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/reporters'
require 'rack/test'

require_relative '../time_manager'

Minitest::Reporters.use!

# Main test class for main application
class TimeManagerTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_index
    get '/'

    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']

    assert_includes last_response.body, '<h1>Welcome to Time Manager!</h1>'
    assert_includes last_response.body, '<h2>New here?</h2>'
    assert_includes last_response.body, '<h2>Already a user?</h2>'
    assert_includes last_response.body, '<img width="50px" src="/images/github.png">'
    assert_includes last_response.body, '<a class="nav-link" href="/">'
    assert_includes last_response.body, '<a class="nav-link" href="/help">'
    assert_includes last_response.body, '<a class="nav-link" href="/about">'
    assert_includes last_response.body, '<a class="nav-link" href="/sign-in">'
  end

  def test_home
    get '/home'

    assert_equal 302, last_response.status

    # Redirect to index
    get last_response['Location']

    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']

    # Make sure it redirects to index
    assert_includes last_response.body, '<h1>Welcome to Time Manager!</h1>'
  end
end
