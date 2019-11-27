# frozen_string_literal: true

# Body content assertions for all endpoints -- signed out
module SignedOutAssertions
  def assert_header
    assert_includes last_response.body, '<a class="nav-link" href="/">'
    assert_includes last_response.body, '<a class="nav-link" href="/help">'
    assert_includes last_response.body, '<a class="nav-link" href="/about">'
    assert_includes last_response.body, '<a class="nav-link" href="/sign-in">'
    refute_includes last_response.body, '<a class="nav-link" href="/sign-out">'
    refute_includes last_response.body, '<a class="nav-link" href="/view">'
    refute_includes last_response.body, '<a class="nav-link" href="/actions">'
    refute_includes last_response.body, '<div id="header-name">'
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

  def assert_main_about
    assert_includes last_response.body, '<h2>The Application</h2>'
    assert_includes last_response.body, '<h2>The Creator</h2>'
    assert_includes last_response.body, '<figure id="profile-pic">'
    assert_includes last_response.body, '<img src="/images/profile.png"'
    assert_includes last_response.body, '<figcaption>John Isom</figcaption>'
    assert_includes last_response.body, 'id="disclaimer"'
    assert_includes last_response.body, '<small'
  end

  def assert_main_sign_in
    inputs = <<-HTML
  <input class="input" type="text" name="username" placeholder="Username" value="" autofocus>
  <input class="input" type="password" name="password" placeholder="Password">
    HTML

    assert_includes last_response.body, '<h2>Sign In!</h2>'
    assert_includes last_response.body, inputs
    assert_includes last_response.body, '<button class="button">Sign In</button>'
    assert_includes last_response.body, "<span>Don't have an account? "
    assert_includes last_response.body, '<a href="/sign-up">Sign up!</a>'
  end
end
