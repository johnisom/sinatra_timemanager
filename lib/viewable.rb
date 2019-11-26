# frozen_string_literal: true

require 'date'

require_relative 'default'
require_relative 'daily_digest'
require_relative 'day_delimited'
require_relative 'weekly_digest'
require_relative 'week_delimited'
require_relative 'timeable'

class NoViewDataError < StandardError
end

class InvalidFiltersError < StandardError
end

# Viewable module to add view methods to TimeManager class
module Viewable
  include Default
  include DailyDigest
  include DayDelimited
  include WeeklyDigest
  include WeekDelimited
  include Timeable
  
  SEC_IN_DAY = 24 * 60 * 60

  def view(timeframe_from, timeframe_to, view_option)
    raise NoViewDataError, "Can't view without any data!" if @sessions.empty?

    timeframe_from, timeframe_to = convert_timeframes(timeframe_from,
                                                      timeframe_to)

    if (error = error_for_timeframes(timeframe_from, timeframe_to))
      raise InvalidFiltersError, error
    end

    case view_option
    when 'default', nil   then        default(timeframe_from, timeframe_to)
    when 'daily-digest'   then   daily_digest(timeframe_from, timeframe_to)
    when 'day-delimited'  then  day_delimited(timeframe_from, timeframe_to)
    when 'weekly-digest'  then  weekly_digest(timeframe_from, timeframe_to)
    when 'week-delimited' then week_delimited(timeframe_from, timeframe_to)
    else raise InvalidFiltersError, "View option not valid."
    end
  end

  private

  def convert_timeframes(timeframe_from, timeframe_to)
    timeframe_to = timeframe_to.to_i
    timeframe_from = if timeframe_from.nil? || timeframe_from == ''
                       max_timeframe
                     else
                       timeframe_from.to_i
                     end

    [timeframe_from, timeframe_to]
  end

  def error_for_timeframes(timeframe_from, timeframe_to)
    if timeframe_from < timeframe_to
      'Invalid timeframe range.'
    end
  end

  def max_timeframe
    (Time.now.to_date - @sessions.first.start.time.to_date).to_i
  end

  def sessions_in_timeframe(from, to)
    today = Time.now.to_date
    date_range = (today - from)..(today - to)
    @sessions.select do |session|
      date_range.cover? session.start.time.to_date
    end
  end

  def timeframe_html(from, to)
    days = lambda { |n| n != 1 ? 'days' : 'day' }
    <<~HTML
      <div class="preamble">
        <span>Showing results from </span>
        <span class="timeframe-display">#{from}</span>
        <span>#{days.call(from)} ago to </span>
        <span class="timeframe-display">#{to}</span>
        <span>#{days.call(to)} ago</span>
      </div>
    HTML
  end

  def choice_html(display_name)
    <<~HTML
      <div class="preamble">
        <span>Chosen display: </span>
        <span id="choice">#{display_name}</span>
      </div>
    HTML
  end

  def summaries_html(avg_sec, tot_sec, avg_timeframe = 'per day')
    <<~HTML
      <br>
      <div class="summary">
        <span class="title">Average: </span>
        <span class="content">#{time_elapsed(avg_sec)}</span>
        <span class="footer"> #{avg_timeframe}<span>
      </div>
      <div class="summary">
        <span class="title">Total: </span>
        <span class="content">#{time_elapsed(tot_sec)}</span>
      </div>
    HTML
  end
end
