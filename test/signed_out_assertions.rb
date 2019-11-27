# frozen_string_literal: true

# Body content assertions for all endpoints -- signed out
module SignedOutAssertions
  def assert_header
    assert_includes last_response.body, '<a class="nav-link" href="/">'
    assert_includes last_response.body, '<a class="nav-link" href="/help">'
    assert_includes last_response.body, '<a class="nav-link" href="/about">'
    assert_includes last_response.body, '<a class="nav-link" href="/sign-in">'
  end

  def assert_main_index
    assert_includes last_response.body, '<h1>Welcome to Time Manager!</h1>'
    assert_includes last_response.body, '<h2>New here?</h2>'
    assert_includes last_response.body, "<h3>Don't worry. I'm here to help.</h3>"
    assert_includes last_response.body, '<h2>Already a user?</h2>'
    assert_includes last_response.body, '<h3>You know the drill.</h3>'
  end

  def assert_main_help
    assert_includes last_response.body, '<h1>Help</h1>'
    assert_includes last_response.body, '<span class="toc-title">Table of'
    assert_includes last_response.body, '<h2 id="view">View</h2>'
    assert_includes last_response.body, '<h3 id="timeframe">Timeframe</h3>'
    assert_includes last_response.body, '<h3 id="view-options">View Options</h3>'
    assert_includes last_response.body, '<h4 id="day-delimited">Day Delimited</h4>'
    assert_includes last_response.body, '<h2 id="start">Start</h2>'
    assert_includes last_response.body, '<h2 id="stop">Stop</h2>'
    assert_includes last_response.body, '<h2 id="undo">Undo</h2>'
    assert_includes last_response.body, '<strong class="warning">'
  end
end
