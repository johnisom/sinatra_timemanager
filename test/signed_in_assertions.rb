# frozen_string_literal: true

require_relative 'common_assertions'

# Body content assertions for all endpoints -- signed in
module SignedInAssertions
  include CommonAssertions

  def assert_header
    assertions = []

    refutations = []

    assert_and_refute(assertions, refutations)
  end

  def assert_main_index
    assertions = []

    refutations = []

    assert_and_refute(assertions, refutations)
  end

  def assert_main_sign_out
    assertions = []

    refutations = []

    assert_and_refute(assertions, refutations)
  end
end
