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

  def test_get_sign_up
    get '/sign-up'

    assert_status_and_content_type
    assert_header
    assert_main_sign_up
    assert_footer
  end

  def test_get_sign_out
    assert_get_authorization '/sign-out'
  end

  def test_get_view
    assert_get_authorization '/view'
  end

  def test_actions
    assert_get_authorization '/actions'
  end

  def test_get_undo
    assert_get_authorization '/actions'
  end

  def test_not_found
    super

    assert_header
    assert_main_index
  end
end
