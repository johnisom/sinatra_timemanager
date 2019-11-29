# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/reporters'

require_relative 'base'
require_relative 'signed_in_assertions'

Minitest::Reporters.use!

# Signed out tests
class SignedInTest < BaseTest
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
    skip
  end

  def test_post_sign_out
    skip
  end

  def test_view_default
    skip
  end

  def test_view_daily_digest
    skip
  end

  def test_view_day_delimited
    skip
  end

  def test_view_weekly_digest
    skip
  end

  def test_view_week_delimited
    skip
  end

  def test_view_default_16_to_13
    skip
  end

  def test_view_daily_digest_16_to_13
    skip
  end

  def test_view_day_delimited_16_to_13
    skip
  end

  def test_view_weekly_digest_16_to_13
    skip
  end

  def test_view_week_delimited_16_to_13
    skip
  end

  def test_actions
    skip
  end

  def test_start_no_message
    skip
  end

  def test_start_message
    skip
  end

  def test_stop_no_message
    skip
  end

  def test_stop_message
    skip
  end

  def test_get_undo
    skip
  end

  def test_post_undo
    skip
  end

  def test_back_out_undo
    skip
  end

  def test_not_found
    super

    assert_header
    assert_main_index
  end
end
