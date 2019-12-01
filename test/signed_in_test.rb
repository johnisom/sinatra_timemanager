# frozen_string_literal: true

require 'coveralls'
Coveralls.wear!

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/reporters'
require 'rack'

require_relative 'base'
require_relative 'signed_in_assertions'

Minitest::Reporters.use!

# Signed in tests
class SignedInTest < BaseTest # rubocop:disable Metrics/ClassLength
  include SignedInAssertions

  def auth_error_message
    super('out')
  end

  def session
    super(username: 'test')
  end

  # helper method for starts
  def helper_start_test(message, encoded_message = nil)
    post '/start', { message: message }, session

    assert_equal 302, last_response.status
    assert_flash 'Time started.'
    assert_time_start(encoded_message || message)

    # follow redirect back to actions page
    get last_response['Location']

    assert_all_actions
    assert_displayed_flash 'Time started.'
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

    assert_all_actions
    assert_displayed_flash "Can't view without any data!", :danger
  end

  def test_view_default
    get '/view', {}, session

    assert_all_view
    assert_content_view 'DEFAULT'
  end

  def test_view_daily_digest
    get '/view', { view_option: 'daily-digest' }, session

    assert_all_view
    assert_content_view 'DAILY DIGEST'
  end

  def test_view_day_delimited
    get '/view', { view_option: 'day-delimited' }, session

    assert_all_view
    assert_content_view 'DAY DELIMITED'
  end

  def test_view_weekly_digest
    get '/view', { view_option: 'weekly-digest' }, session

    assert_all_view
    assert_content_view 'WEEKLY DIGEST'
  end

  def test_view_week_delimited
    get '/view', { view_option: 'week-delimited' }, session

    assert_all_view
    assert_content_view 'WEEK DELIMITED'
  end

  def test_view_default_with_timeframe
    get '/view', { timeframe_from: 13, timeframe_to: 8 }, session

    assert_all_view
    assert_content_view 'DEFAULT'
    assert_timeframe_view 13, 8
  end

  def test_view_daily_digest_with_timeframe
    params = { view_option: 'daily-digest',
               timeframe_from: 13, timeframe_to: 8 }
    get '/view', params, session

    assert_all_view
    assert_content_view 'DAILY DIGEST'
    assert_timeframe_view 13, 8
  end

  def test_view_day_delimited_with_timeframe
    params = { view_option: 'day-delimited',
               timeframe_from: 26, timeframe_to: 2 }
    get '/view', params, session

    assert_all_view
    assert_content_view 'DAY DELIMITED'
    assert_timeframe_view 26, 2
  end

  def test_view_weekly_digest_with_timeframe
    params = { view_option: 'weekly-digest',
               timeframe_from: 5, timeframe_to: 4 }
    get '/view', params, session

    assert_all_view
    assert_content_view 'WEEKLY DIGEST'
    assert_timeframe_view 5, 4
  end

  def test_view_week_delimited_with_timeframe
    params = { view_option: 'week-delimited',
               timeframe_from: 90, timeframe_to: 34 }
    get '/view', params, session

    assert_all_view
    assert_content_view 'WEEK DELIMITED'
    assert_timeframe_view 90, 34
  end

  def test_view_negative_timeframe
    get '/view', { timeframe_from: -1, timeframe_to: -4 }, session

    assert_all_view
    assert_displayed_flash 'Timeframe cannot be negative.', :danger
    assert_includes last_response.body, '<div id="shrug">¯\_(ツ)_/¯</div>'
  end

  def test_view_invalid_timeframe
    get '/view', { timeframe_from: 5, timeframe_to: 6 }, session

    assert_all_view
    assert_displayed_flash 'Invalid timeframe range.', :danger
    assert_includes last_response.body, '<div id="shrug">¯\_(ツ)_/¯</div>'
  end

  def test_actions
    get '/actions', {}, session

    assert_all_actions
  end

  def test_start_no_message
    helper_start_test ''
  end

  def test_start_message
    helper_start_test 'An example message'
  end

  def test_start_hack_message
    message = '<script>alert("Will this alert?");</script>'
    encoded_message = Rack::Utils.escape_html(message)

    helper_start_test message, encoded_message
  end

  def test_start_twice
    post '/start', { message: '' }, session
    post '/start', { message: '' }, session

    assert_all_actions
    assert_displayed_flash "Can't start twice in a row!", :danger
  end

  # helper method for stops
  def helper_stop_test(message, encoded_message = nil)
    post '/start', { message: '' }, session # to avoid stop twice error
    post '/stop', { message: message }, session

    assert_equal 302, last_response.status
    assert_flash 'Time stopped.'
    assert_time_stop(encoded_message || message)

    # follow redirect back to actions page
    get last_response['Location']

    assert_all_actions
    assert_displayed_flash 'Time stopped.'
  end

  def test_stop_no_message
    helper_stop_test ''
  end

  def test_stop_message
    helper_stop_test 'An example message'
  end

  def test_stop_hack_message
    message = '<script>alert("Will this alert?");</script>'
    encoded_message = Rack::Utils.escape_html(message)

    helper_stop_test message, encoded_message
  end

  def test_stop_twice
    post '/stop', { message: '' }, session

    assert_all_actions
    assert_displayed_flash "Can't stop twice in a row!", :danger
  end

  def test_get_undo
    get '/undo', {}, session

    assert_status_and_content_type
    assert_header
    assert_main_undo
    assert_footer
  end

  def test_post_undo # rubocop:disable Metrics/AbcSize
    post '/start', { message: 'this will be kept' }, session
    post '/stop', { message: 'this will be removed' }, session
    post '/undo', {}, session

    assert_equal 302, last_response.status
    assert_flash 'Last entry undone.'
    assert_time_start 'this will be kept'

    # follow redirect back to home/index page
    get last_response['Location']

    assert_all_actions
    assert_displayed_flash 'Last entry undone.'
  end

  def test_max_undo
    test_session = { 'rack.session' => { username: 'empty_test' } }
    post '/start', { message: '' }, test_session
    post '/undo', {}, test_session
    post '/undo', {}, test_session

    assert_all_actions
    assert_displayed_flash "Can't undo any more!", :danger
  end

  def test_not_found
    super

    assert_header
    assert_main_index
  end
end
