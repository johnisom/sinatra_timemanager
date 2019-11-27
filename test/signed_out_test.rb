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
    get '/'

    assert_status_and_content_type
    assert_header
    assert_main_index
  end

  def test_home
    get '/home'

    assert_equal 302, last_response.status

    # Redirect to index
    get last_response['Location']

    assert_status_and_content_type

    # Make sure it redirects to index
    assert_header
    assert_main_index
  end

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

  def test_sign_in
    get '/sign-in'

    assert_status_and_content_type
    assert_header
    assert_main_sign_in
  end

  def test_sign_up
    get '/sign-up'

    assert_status_and_content_type
    assert_header
    assert_main_sign_up
  end
end
