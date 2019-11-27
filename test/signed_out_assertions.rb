# frozen_string_literal: true

# Body content assertions for all endpoints -- signed out
module SignedOutAssertions
  def assert_and_refute(assertions, refutations)
    body = last_response.body

    assertions.each { |str| assert_includes body, str }
    refutations.each { |str| refute_includes body, str }
  end

  def assert_header
    assertions = ['<a class="nav-link" href="/">',
                  '<a class="nav-link" href="/help">',
                  '<a class="nav-link" href="/about">',
                  '<a class="nav-link" href="/sign-in">']

    refutations = ['<a class="nav-link" href="/sign-out">',
                   '<a class="nav-link" href="/view">',
                   '<a class="nav-link" href="/actions">',
                   '<div id="header-name">']

    assert_and_refute(assertions, refutations)
  end

  def assert_main_index
    assertions = ['<h1>Welcome to Time Manager!</h1>', '<h2>New here?</h2>',
                  "<h3>Don't worry. I'm here to help.</h3>",
                  '<h2>Already a user?</h2>', '<h3>You know the drill.</h3>']

    refutations = []

    assert_and_refute(assertions, refutations)
  end

  def assert_main_help
    assertions = ['<h1>Help</h1>', '<span class="toc-title">Table of',
                  '<h2 id="view">View</h2>', '<h3 id="timeframe">Timeframe</h3>',
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

  def assert_main_sign_in
    inputs = <<-HTML
  <input class="input" type="text" name="username" placeholder="Username" value="" autofocus>
  <input class="input" type="password" name="password" placeholder="Password">
    HTML

    assertions = ['<h2>Sign In!</h2>', inputs,
                  '<button class="button">Sign In</button>',
                  "<span>Don't have an account? ",
                  '<a href="/sign-up">Sign up!</a>']

    refutations = []

    assert_and_refute(assertions, refutations)
  end

  def assert_main_sign_up
    inputs = <<-HTML
  <input class="input" type="text" name="username" placeholder="Username" value="" autofocus>
  <input class="input" type="password" name="password" placeholder="Password">
    HTML

    assertions = ['<h2>Sign Up!</h2>', inputs,
                  '<button class="button">Sign Up</button>']

    refutations = []

    assert_and_refute(assertions, refutations)
  end
end
