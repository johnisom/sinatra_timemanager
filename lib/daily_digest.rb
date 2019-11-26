# frozen_string_literal: true

require_relative 'timeable'

# Daily Digest viewing module
module DailyDigest
  private

  include Timeable

  def daily_digest(from, to)
    days = days(from, to)
    day_seconds = days.map { |sessions| sessions.sum(&:seconds) }

    tot_sec = day_seconds.sum
    avg_sec = begin tot_sec / days.size
              rescue ZeroDivisionError; 0
              end

    timeframe_html(from, to) +
      choice_html('DAILY DIGEST') +
      daily_digest_content(day_dates(days), day_seconds) +
      summaries_html(avg_sec, tot_sec, 'per logged day')
  end

  def day_dates(days)
    days.map do |sessions|
      sessions[0].start.time.to_date
    end
  end

  def daily_digest_content(dates, day_seconds)
    dates.zip(day_seconds).map do |date, seconds|
      <<~HTML
        <div class="summary">
          <span class="title">#{strfdate(date)}: </span>
          <span class="content">#{time_elapsed(seconds)}</span>
        </div>
      HTML
    end.join
  end
end
