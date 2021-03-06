# frozen_string_literal: true

require 'time'

require_relative '../lib/tm.rb'

# Body content assertions for all endpoints -- signed in
module SignedInAssertions # rubocop:disable Metrics/ModuleLength
  def assert_header
    assertions = ['<a class="nav-link" href="/">',
                  '<a class="nav-link" href="/help">',
                  '<a class="nav-link" href="/about">',
                  '<a class="nav-link" href="/view">',
                  '<a class="nav-link" href="/actions">',
                  '<a class="nav-link" href="/sign-out">',
                  '<div id="header-name">']

    refutations = ['<a class="nav-link" href="/sign-in">']

    assert_and_refute assertions, refutations
  end

  def assert_main_index
    assertions = ['<h2>Click one of the above buttons to get started, ',
                  '<span class="name">', '</span>!']

    refutations = ['<h1>Welcome to Time Manager!</h1>', '<h2>New here?</h2>',
                   "<h3>Don't worry. I'm here to help.</h3>",
                   '<h2>Already a user?</h2>',
                   '<h3>You know the drill.</h3>']

    assert_and_refute assertions, refutations
  end

  # rubocop:disable Metrics/MethodLength
  def assert_main_sign_out
    button1 = <<-HTML
  <form class="flex-vertical" action="/sign-out" method="POST">
    <button class="button">Yes, sign me out</button>
  </form>
    HTML

    button2 = <<-HTML
  <form class="flex-vertical" action="/">
    <button class="button">No, I changed my mind</button>
  </form>
    HTML

    assertions = ['<h2>Are you sure you want to sign out?</h2>',
                  button1, button2]

    refutations = []

    assert_and_refute assertions, refutations
  end

  def assert_main_actions
    start_form = <<-HTML
  <form class="flex-vertical spaced-form" action="/start" method="POST">
    <h2 class="text-center">Start</h2>
    <input class="input" type="text" name="message" placeholder="Optional message...">
    <button class="button">Start</button>
  </form>
    HTML

    stop_form = <<-HTML
  <form class="flex-vertical spaced-form" action="/stop" method="POST">
    <h2 class="text-center">Stop</h2>
    <input class="input" type="text" name="message" placeholder="Optional message...">
    <button class="button">Stop</button>
  </form>
    HTML

    undo_form = <<-HTML
  <form class="flex-vertical spaced-form" action="/undo">
    <h2 class="text-center">Undo</h2>
    <button id="undo-button" class="button">Undo</button>
  </form>
    HTML

    assertions = [start_form, stop_form, undo_form]

    refutations = []

    assert_and_refute assertions, refutations
  end

  def assert_main_undo
    buttons = <<-HTML
  <form class="flex-vertical" action="/undo" method="POST">
    <button class="button">Yes</button>
  </form>

  <form class="flex-vertical" action="/actions">
    <button class="button">No</button>
  </form>
    HTML

    assertions = ['<h2>Are you sure you want to undo the last entry?</h2>',
                  '<h3 class="text-center">(This cannot be undone!)</h3>',
                  buttons]

    refutations = []

    assert_and_refute assertions, refutations
  end

  def assert_main_view
    assertions = ['<div id="view-content">', '<h2>Filter Results</h2>',
                  '<h3>Select Timeframe</h3>',
                  '<input class="input timeframe" name="timeframe_from" '\
                  'type="number" min="0" placeholder="from _ days ago"',
                  '<input class="input timeframe" name="timeframe_to" '\
                  'type="number" min="0" placeholder="up to _ days ago"',
                  '<h3>Select View Option</h3>',
                  '<select class="input" name="view_option">',
                  '<button class="button">Apply Filters</button>']

    refutations = []

    assert_and_refute assertions, refutations
  end

  def assert_content_view(mode)
    assertions = ['<div class="preamble">',
                  "<span>Chosen display: </span>\n  "\
                  "<span id=\"choice\">#{mode}</span>",
                  '<span>Showing results from </span>',
                  '<span class="title">Average: </span>',
                  '<span class="title">Total: </span>']

    refutations = []

    assert_and_refute assertions, refutations
  end

  def assert_timeframe_view(from, to)
    timeframe_preamble = <<~HTML
      <div class="preamble">
        <span>Showing results from </span>
        <span class="timeframe-display">#{from}</span>
        <span>days ago to </span>
        <span class="timeframe-display">#{to}</span>
        <span>days ago</span>
      </div>
    HTML

    assertions = [timeframe_preamble]

    refutations = []

    assert_and_refute assertions, refutations
  end

  # rubocop:enable Metrics/MethodLength

  def assert_time_start(message)
    last_session = TM.new('test').last_session
    start = last_session.start

    refute_predicate last_session, :complete?
    assert_equal message, start.message
    assert Time.now - start.time < 1
  end

  def assert_time_stop(message)
    last_session = TM.new('test').last_session
    stop = last_session.stop

    assert_predicate last_session, :complete?
    assert_equal message, stop.message
    assert Time.now - stop.time < 1
  end

  def assert_all_actions
    assert_status_and_content_type
    assert_header
    assert_main_actions
    assert_footer
  end

  def assert_all_view
    assert_status_and_content_type
    assert_header
    assert_main_view
    assert_footer
  end
end
