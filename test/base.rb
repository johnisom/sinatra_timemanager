# frozen_string_literal: true

require 'rack/test'
require 'minitest/test'
require 'fileutils'

require_relative '../time_manager'
require_relative 'common_assertions'

# Base test class for signed in and signed out tests
class BaseTest < Minitest::Test
  include Rack::Test::Methods
  include CommonAssertions

  def app
    Sinatra::Application
  end

  def auth_error_message(magic_word)
    "You must be signed #{magic_word} to do that."
  end

  def session(**session_info)
    { 'rack.session' => session_info }
  end

  def flash
    last_request.env['rack.session'][:flash]
  end

  def setup
    require 'pry'; binding.pry
    FileUtils.mkdir_p(Sinatra::Application::CREDS_PATH)
  end

  def teardown
    FileUtils.rm_r(Sinatra::Application::CURR_PATH)
  end

  def test_index
    get '/'

    assert_status_and_content_type
    assert_footer
  end

  def test_home
    get '/home'

    assert_equal 302, last_response.status

    # follow redirect back to index/home page
    get last_response['Location']

    assert_status_and_content_type
    assert_footer
  end

  def test_help
    get '/help'

    assert_status_and_content_type
    assert_main_help
    assert_footer
  end

  def test_about
    get '/about'

    assert_status_and_content_type
    assert_main_about
    assert_footer
  end

  def test_not_found
    get '/not/a/path'

    assert_equal 302, last_response.status

    # follow redirect back to index/home page
    get last_response['Location']

    assert_status_and_content_type
    assert_flash "That page doesn't exist", 'danger'
    assert_footer
  end
end
