# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/reporters'
require 'rack'

require_relative 'base'
require_relative 'signed_in_assertions'

Minitest::Reporters.use!

# Signed out tests
class SignedInTest < BaseTest # rubocop:disable Metrics/ClassLength
  include SignedInAssertions

  def auth_error_message
    super('out')
  end

  def session
    super(username: 'test')
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
    assert_get_authorization '/sign-in'
  end

  def test_post_sign_in
    assert_post_authorization '/sign-in', username: 'test', password: 'test123@'
  end

  def test_get_sign_up
    assert_get_authorization '/sign-up'
  end

  def test_post_sign_up
    assert_post_authorization '/sign-up', username: 'hi', password: 'w0rld$8d'
  end

  def test_get_sign_out
    get '/sign-out', {}, session

    assert_status_and_content_type
    assert_header
    assert_main_sign_out
    assert_footer
  end

  def test_post_sign_out
    post '/sign-out', {}, session

    assert_equal 302, last_response.status
    assert_flash 'You were successfully signed out.', :success

    # follow redirect back to home/index page
    get last_response['Location']

    assert_status_and_content_type
    assert_footer
    assert_displayed_flash 'You were successfully signed out.', :success
  end

  def test_view_no_data
    test_session = { 'rack.session' => { username: 'empty_test' } }
    get '/view', {}, test_session

    assert_equal 302, last_response.status
    assert_flash "Can't view without any data!", :danger

    # follow redirect to actions page
    get last_response['Location'], {}, test_session

    assert_status_and_content_type
    assert_header
    assert_main_actions
    assert_footer
    assert_displayed_flash "Can't view without any data!", :danger
  end

  # helper method for view tests
  def helper_view_test
    get '/view', {}, session

    assert_status_and_content_type
    assert_header
    assert_main_view
    assert_footer
  end

  def test_view_default
    helper_view_test
  end

  def test_view_daily_digest
    skip
    helper_view_test
  end

  def test_view_day_delimited
    skip
    helper_view_test
  end

  def test_view_weekly_digest
    skip
    helper_view_test
  end

  def test_view_week_delimited
    skip
    helper_view_test
  end

  def test_view_default_16_to_13
    skip
    helper_view_test
  end

  def test_view_daily_digest_16_to_13
    skip
    helper_view_test
  end

  def test_view_day_delimited_16_to_13
    skip
    helper_view_test
  end

  def test_view_weekly_digest_16_to_13
    skip
    helper_view_test
  end

  def test_view_week_delimited_16_to_13
    skip
    helper_view_test
  end

  def test_actions
    get '/actions', {}, session

    assert_status_and_content_type
    assert_header
    assert_main_actions
    assert_footer
  end

  def test_start_no_message
    post '/start', {message: ''}, session

    assert_equal 302, last_response.status
    assert_flash 'Time started.'
    assert_time_start ''

    # follow redirect back to actions page
    get last_response['Location'], {}, session

    assert_status_and_content_type
    assert_header
    assert_main_actions
    assert_footer
    assert_displayed_flash 'Time started.'
  end

  def test_start_message
    post '/start', {message: 'An example message'}, session

    assert_equal 302, last_response.status
    assert_flash 'Time started.'
    assert_time_start 'An example message'

    # follow redirect back to actions page
    get last_response['Location'], {}, session

    assert_status_and_content_type
    assert_header
    assert_main_actions
    assert_footer
    assert_displayed_flash 'Time started.'
  end

  def test_start_hack_message
    message = '<script>alert("Will this alert?");</script>'

    post '/start', {message: message}, session

    assert_equal 302, last_response.status
    assert_flash 'Time started.'
    assert_time_start Rack::Utils.escape_html(message)

    # follow redirect back to actions page
    get last_response['Location'], {}, session

    assert_status_and_content_type
    assert_header
    assert_main_actions
    assert_footer
    assert_displayed_flash 'Time started.'
  end

  def test_start_twice
    post '/start', {message: ''}, session
    post '/start', {message: ''}, session

    assert_status_and_content_type
    assert_header
    assert_main_actions
    assert_footer
    assert_displayed_flash "Can't start twice in a row!", :danger
  end

  def test_stop_no_message
    post '/start', {message: ''}, session # to avoid stop twice error
    post '/stop', {message: ''}, session

    assert_equal 302, last_response.status
    assert_flash 'Time stopped.'
    assert_time_stop ''

    # follow redirect back to actions page
    get last_response['Location'], {}, session

    assert_status_and_content_type
    assert_header
    assert_main_actions
    assert_footer
    assert_displayed_flash 'Time stopped.'
  end

  def test_stop_message
    post '/start', {message: ''}, session # to avoid stop twice error
    post '/stop', {message: 'An example message'}, session

    assert_equal 302, last_response.status
    assert_flash 'Time stopped.'
    assert_time_stop 'An example message'

    # follow redirect back to actions page
    get last_response['Location'], {}, session

    assert_status_and_content_type
    assert_header
    assert_main_actions
    assert_footer
    assert_displayed_flash 'Time stopped.'
  end

  def test_stop_hack_message
    message = '<script>alert("Will this alert?");</script>'

    post '/start', {message: ''}, session # to avoid stop twice error
    post '/stop', {message: message}, session

    assert_equal 302, last_response.status
    assert_flash 'Time stopped.'
    assert_time_stop Rack::Utils.escape_html(message)

    # follow redirect back to actions page
    get last_response['Location'], {}, session

    assert_status_and_content_type
    assert_header
    assert_main_actions
    assert_footer
    assert_displayed_flash 'Time stopped.'
  end

  def test_stop_twice
    post '/stop', {message: ''}, session

    assert_status_and_content_type
    assert_header
    assert_main_actions
    assert_footer
    assert_displayed_flash "Can't stop twice in a row!", :danger
  end

  def test_get_undo
    get '/undo', {}, session

    assert_status_and_content_type
    assert_header
    assert_main_undo
    assert_footer
  end

  def test_post_undo
    post '/start', { message: 'this will be kept' }, session
    post '/stop', { message: 'this will be removed' }, session
    post '/undo', {}, session

    assert_equal 302, last_response.status
    assert_flash 'Last entry undone.'
    assert_time_start 'this will be kept'

    # follow redirect back to home/index page
    get last_response['Location']

    assert_status_and_content_type
    assert_header
    assert_main_actions
    assert_footer
    assert_displayed_flash 'Last entry undone.'
  end

  def test_max_undo
    test_session = { 'rack.session' => { username: 'empty_test' } }
    post '/start', { message: '' }, test_session
    post '/undo', {}, test_session
    post '/undo', {}, test_session

    assert_status_and_content_type
    assert_header
    assert_main_actions
    assert_footer
    assert_displayed_flash "Can't undo any more!", :danger
  end

  def test_not_found
    super

    assert_header
    assert_main_index
  end
end
