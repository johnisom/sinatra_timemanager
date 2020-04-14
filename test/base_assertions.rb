# frozen_string_literal: true

# Body content assertions common to being both signed in and signed out
module BaseAssertions
  def assert_and_refute(assertions, refutations)
    body = last_response.body

    assertions.each { |str| assert_includes body, str }
    refutations.each { |str| refute_includes body, str }
  end

  def assert_status_and_content_type
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
  end

  def assert_flash(message, type = :neutral)
    assert_equal message, flash[:message]
    assert_equal type, flash[:type]
  end

  def assert_displayed_flash(message, type = :neutral)
    assertions = [%(<div class="flash #{type} center-child">),
                  message, '</div>']

    refutations = []

    assert_and_refute(assertions, refutations)
  end

  def assert_footer
    assertions = ['<footer class="flex evenly">',
                  'href="https://github.com/johnisom/sinatra_timemanager"',
                  '<img width="50px" src="/images/github.png">',
                  'John Isom', '<small class="name">&copy; 2020</small>']

    refutations = []

    assert_and_refute assertions, refutations
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

    assert_and_refute assertions, refutations
  end

  def assert_main_about
    assertions = ['<h2>The Application</h2>', '<h2>The Creator</h2>',
                  '<figure id="profile-pic">', '<img src="/images/profile.png"',
                  '<figcaption>John Isom</figcaption>',
                  'id="disclaimer"', '<small']

    refutations = []

    assert_and_refute assertions, refutations
  end

  def assert_authorization
    assert_equal 302, last_response.status
    assert_flash auth_error_message, :danger

    # follow redirect back to index/home page
    get last_response['Location']

    assert_status_and_content_type
    assert_header
    assert_main_index
    assert_footer
  end

  def assert_get_authorization(path, **params)
    get path, params, session
    assert_authorization
  end

  def assert_post_authorization(path, **params)
    post path, params, session
    assert_authorization
  end
end
