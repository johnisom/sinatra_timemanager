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
    assert_get_authorization '/sign-in', username: 'user', password: 'pass'
  end
end
