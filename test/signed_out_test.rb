# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/reporters'

require_relative 'base'
require_relative 'signed_out_assertions'

Minitest::Reporters.use!

# Signed out tests
class SignedOutTest < BaseTest
  include SignedOutAssertions

  def auth_error_message
    super('in')
  end

  def test_index
    super

    assert_header
    assert_main_index
  end

  def test_home
    super

    assert_header
    assert_main_index
  end

  def test_help
    super

    assert_header
  end

  def test_about
    super

    assert_header
  end

  def test_get_sign_in
    get '/sign-in'

    assert_status_and_content_type
    assert_header
    assert_main_sign_in
    assert_footer
  end

  def test_post_sign_in_successfull
    post '/sign-in', username: 'test', password: 'test123@'

    assert_equal 302, last_response.status
    assert_equal 'You were successfully signed in.', flash[:message]
    assert_equal :success, flash[:type]

    # follow redirect back to home/index page
    get last_response['Location']

    assert_status_and_content_type
    assert_flash 'You were successfully signed in.', :success
    assert_footer
  end

  def test_post_sign_in_wrong_username

  end

  def test_get_sign_up
    get '/sign-up'

    assert_status_and_content_type
    assert_header
    assert_main_sign_up
    assert_footer
  end

  def test_post_sign_up_successfull
    post '/sign-up', username: 'tmp', password: 'tmp123@#'

    assert_equal 302, last_response.status
    assert_equal 'Welcome aboard, tmp!', flash[:message]
    assert_equal :success, flash[:type]

    # follow redirect back to home/index page
    get last_response['Location']

    assert_status_and_content_type
    assert_flash 'Welcome aboard, tmp!', :success
    assert_footer
  end

  def 

  def test_get_sign_out
    assert_get_authorization '/sign-out'
  end

  def test_post_sign_out
    assert_post_authorization '/sign-out'
  end

  def test_get_view
    assert_get_authorization '/view'
  end

  def test_get_view_with_params
    assert_get_authorization '/view', timeframe_from: 5, timeframe_to: 2
  end

  def test_actions
    assert_get_authorization '/actions'
  end

  def test_start_no_message
    assert_post_authorization '/start'
  end

  def test_start_message
    assert_post_authorization '/start', message: 'A test message for a test!'
  end

  def test_stop_no_message
    assert_post_authorization '/stop'
  end

  def test_stop_message
    assert_post_authorization '/stop', message: 'A test message for a test!'
  end

  def test_get_undo
    assert_get_authorization '/undo'
  end

  def test_post_undo
    assert_post_authorization '/undo'
  end

  def test_not_found
    super

    assert_header
    assert_main_index
  end
end
