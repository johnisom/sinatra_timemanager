# frozen_string_literal: true

# Body content assertions common to being both signed in and signed out
module CommonAssertions
  def assert_and_refute(assertions, refutations)
    body = last_response.body

    assertions.each { |str| assert_includes body, str }
    refutations.each { |str| refute_includes body, str }
  end

  def assert_main_help
    assertions = ['<h1>Help</h1>', '<span class="toc-title">Table of',
                  '<h2 id="view">View</h2>',
                  '<h3 id="timeframe">Timeframe</h3>',
                  '<h3 id="view-options">View Options</h3>',
                  '<h4 id="day-delimited">Day Delimited</h4>',
                  '<h2 id="start">Start</h2>', '<h2 id="stop">Stop</h2>',
                  '<h2 id="undo">Undo</h2>']

    refutations = []

    assert_and_refute(assertions, refutations)
  end

  def assert_main_about
    assertions = ['<h2>The Application</h2>', '<h2>The Creator</h2>',
                  '<figure id="profile-pic">', '<img src="/images/profile.png"',
                  '<figcaption>John Isom</figcaption>',
                  'id="disclaimer"', '<small']

    refutations = []

    assert_and_refute(assertions, refutations)
  end
end
