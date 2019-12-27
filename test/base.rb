# frozen_string_literal: true

require 'rack/test'
require 'minitest/test'
require 'fileutils'
require 'pg'

require_relative '../time_manager'
require_relative 'base_assertions'

# Base test class for signed in and signed out tests
class BaseTest < Minitest::Test
  include Rack::Test::Methods
  include BaseAssertions

  def app
    Sinatra::Application
  end

  def setup
    @tmp_uname = SecureRandom.hex(5)
  end

  def teardown
    connection = PG.connect(dbname: 'time_manager')

    connection.exec_params(<<~SQL, [@tmp_uname])
      DELETE FROM users
       WHERE username = $1;
    SQL

    connection.close
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

  def test_index
    get '/', {}, session

    assert_status_and_content_type
    assert_footer
  end

  def test_home
    get '/home', {}, session

    assert_equal 302, last_response.status

    # follow redirect back to index/home page
    get last_response['Location'], {}, session

    assert_status_and_content_type
    assert_footer
  end

  def test_help
    get '/help', {}, session

    assert_status_and_content_type
    assert_main_help
    assert_footer
  end

  def test_about
    get '/about', {}, session

    assert_status_and_content_type
    assert_main_about
    assert_footer
  end

  def test_not_found
    get '/not/a/path', {}, session

    assert_equal 302, last_response.status
    assert_flash "That page doesn't exist", :danger

    # follow redirect back to index/home page
    get last_response['Location'], {}, session

    assert_status_and_content_type
    assert_footer
  end
end
