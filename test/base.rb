# frozen_string_literal: true

require 'rack/test'
require 'minitest/test'
require 'fileutils'

require_relative '../time_manager'
require_relative 'base_assertions'

# Base test class for signed in and signed out tests
class BaseTest < Minitest::Test
  include Rack::Test::Methods
  include BaseAssertions

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

  def copy_credentials
    tmp_creds_file_path = File.join(::CREDS_PATH, 'credentials.yml')
    creds_file_path = File.expand_path('../credentials/credentials.yml',
                                       ::CURR_PATH)
    content = File.read(creds_file_path)
    File.write(tmp_creds_file_path, content)
  end

  def copy_data
    tmp_data_file_path = File.join(::DATA_PATH, 'test.yml')
    data_file_path = File.expand_path('../data/test.yml', ::CURR_PATH)
    content = File.read(data_file_path)
    File.write(tmp_data_file_path, content)
  end

  def setup
    FileUtils.mkdir_p(::CREDS_PATH)
    FileUtils.mkdir_p(::DATA_PATH)
    copy_credentials
    copy_data
  end

  def teardown
    FileUtils.rm_r(::CURR_PATH)
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
