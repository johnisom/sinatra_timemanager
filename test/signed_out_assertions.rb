# frozen_string_literal: true

# Body content assertions for all endpoints -- signed out
module SignedOutAssertions
  def assert_header
    assertions = ['<a class="nav-link" href="/">',
                  '<a class="nav-link" href="/help">',
                  '<a class="nav-link" href="/about">',
                  '<a class="nav-link" href="/sign-in">']

    refutations = ['<a class="nav-link" href="/sign-out">',
                   '<a class="nav-link" href="/view">',
                   '<a class="nav-link" href="/actions">',
                   '<div id="header-name">']

    assert_and_refute assertions, refutations
  end

  def assert_main_index
    assertions = ['<h1>Welcome to Time Manager!</h1>', '<h2>New here?</h2>',
                  "<h3>Don't worry. I'm here to help.</h3>",
                  '<h2>Already a user?</h2>', '<h3>You know the drill.</h3>']

    refutations = []

    assert_and_refute assertions, refutations
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

    assert_and_refute assertions, refutations
  end

  def assert_main_sign_up
    inputs = <<-HTML
  <input class="input" type="text" name="username" placeholder="Username" value="" autofocus>
  <input class="input" type="password" name="password" placeholder="Password">
    HTML

    assertions = ['<h2>Sign Up!</h2>', inputs,
                  '<button class="button">Sign Up</button>']

    refutations = []

    assert_and_refute assertions, refutations
  end

  def assert_get_authorization(path, **params)
    get path, params

    assert_equal 302, last_response.status

    # follow redirect back to index/home page
    get last_response['Location']

    assert_status_and_content_type
    assert_header
    assert_flash 'You must be signed in to do that.', :danger
    assert_main_index
    assert_footer
  end

  def assert_post_authorization(path, **params)
    post path, params

    assert_equal 302, last_response.status

    # follow redirect back to index/home page
    get last_response['Location']

    assert_status_and_content_type
    assert_header
    assert_flash 'You must be signed in to do that.', :danger
    assert_main_index
    assert_footer
  end
end
