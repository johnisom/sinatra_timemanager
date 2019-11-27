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

  def test_help
    get '/help'

    assert_status_and_content_type
    assert_header
    assert_main_help
  end

  def test_about
    get '/about'

    assert_status_and_content_type
    assert_header
    assert_main_about
  end
end

