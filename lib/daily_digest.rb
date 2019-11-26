# frozen_string_literal: true

require_relative 'timeable'

# Daily Digest viewing module
module DailyDigest
  private

  include Timeable

  def daily_digest(from, to)
    days = days(from, to)
    day_seconds = days.map { |sessions| sessions.sum(&:seconds) }
    day_dates = days.map do |sessions|
      sessions[0].start.time.to_date
    end

    tot_sec = day_seconds.sum
    avg_sec = tot_sec / (from - to + 1)

    timeframe_html(from, to) +
      choice_html('DAILY DIGEST') +
      daily_digest_content(day_dates, day_seconds) +
      summaries_html(avg_sec, tot_sec)
  end

  def daily_digest_content(day_dates, day_seconds)
    day_dates.zip(day_seconds).map do |date, seconds|
      <<~HTML
        <div class="summary">
          <span class="title">#{strfdate(date)}: </span>
          <span class="content">#{time_elapsed(seconds)}</span>
        </div>
      HTML
    end.join
  end
end
