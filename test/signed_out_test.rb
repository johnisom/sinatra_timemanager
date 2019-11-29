# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/reporters'
require 'rack'

require_relative 'base'
require_relative 'signed_out_assertions'

Minitest::Reporters.use!

# Signed out tests
class SignedOutTest < BaseTest # rubocop:disable Metrics/ClassLength
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

  def test_post_sign_in_successful
    post '/sign-in', username: 'test', password: 'test123@'

    assert_equal 302, last_response.status
    assert_flash 'You were successfully signed in.', :success

    # follow redirect back to home/index page
    get last_response['Location']

    assert_status_and_content_type
    assert_footer
  end

  def test_post_sign_in_wrong_username
    post '/sign-in', username: 'nonexistent', password: 'same'

    assert_status_and_content_type
    assert_header
    assert_main_sign_in 'nonexistent'
    assert_footer
    assert_displayed_flash "Sorry, we couldn't find a "\
                           'username matching nonexistent.', :danger
  end

  def test_post_sign_in_wrong_password
    post '/sign-in', username: 'test', password: 'wrong password'

    assert_status_and_content_type
    assert_header
    assert_main_sign_in 'test'
    assert_footer
    assert_displayed_flash 'Credentials are invalid. Try again.', :danger
  end

  def test_get_sign_up
    get '/sign-up'

    assert_status_and_content_type
    assert_header
    assert_main_sign_up
    assert_footer
  end

  def test_post_sign_up_successful
    post '/sign-up', username: 'tmp', password: 'tmp123@#'

    assert_equal 302, last_response.status
    assert_flash 'Welcome aboard, tmp!', :success

    # follow redirect back to home/index page
    get last_response['Location']

    assert_status_and_content_type
    assert_footer
  end

  def test_post_sign_up_username_too_short
    post '/sign-up', username: 'a', password: 'valid123#$'

    assert_status_and_content_type
    assert_header
    assert_main_sign_up 'a'
    assert_footer
    assert_displayed_flash 'Username must be between 2 and'\
                          ' 16 characters long.', :danger
  end

  def test_post_sign_up_username_too_long
    post '/sign-up', username: ('a'..'z').to_a.join, password: 'valid123#$'

    assert_status_and_content_type
    assert_header
    assert_main_sign_up(('a'..'z').to_a.join)
    assert_footer
    assert_displayed_flash 'Username must be between 2 and'\
                          ' 16 characters long.', :danger
  end

  def test_post_sign_up_bad_username_chars
    post '/sign-up', username: "6\e\t&s\u1234jk3", password: 'valid123#$'

    assert_status_and_content_type
    assert_header
    assert_main_sign_up Rack::Utils.escape_html("6\e\t&s\u1234jk3")
    assert_footer
    assert_displayed_flash 'Username must only contain alphanumeric'\
                           ' characters (0-9, A-z, _).', :danger
  end

  def test_post_sign_up_taken_username
    post '/sign-up', username: 'test', password: 'valid123#$'

    assert_status_and_content_type
    assert_header
    assert_main_sign_up 'test'
    assert_footer
    assert_displayed_flash 'Sorry, test is already taken.', :danger
  end

  def test_post_sign_up_password_too_short
    post '/sign-up', username: 'valid_uname123', password: '<8chrs'

    assert_status_and_content_type
    assert_header
    assert_main_sign_up 'valid_uname123'
    assert_footer
    assert_displayed_flash 'Password must be between 8 and'\
                           ' 16 characters long.', :danger
  end

  def test_post_sign_up_password_too_long
    post '/sign-up', username: 'valid_uname123', password: 'longerthan16chars!'

    assert_status_and_content_type
    assert_header
    assert_main_sign_up 'valid_uname123'
    assert_footer
    assert_displayed_flash 'Password must be between 8 and'\
                           ' 16 characters long.', :danger
  end

  def test_post_sign_up_bad_password_chars
    post '/sign-up', username: 'valid_uname123', password: 'JustAlphabetic'

    assert_status_and_content_type
    assert_header
    assert_main_sign_up 'valid_uname123'
    assert_footer
    assert_displayed_flash 'Password must contain at least 1 number,'\
                           ' 1 special character, and 1 letter.', :danger
  end

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
