# frozen_string_literal: true

require_relative 'timeable'

# Weekly Digest viewing module
module WeeklyDigest
  private

  include Timeable

  def weekly_digest(from, to)
    weeks = weeks(from, to)
    week_seconds = weeks.map { |sessions| sessions.sum(&:seconds) }
    week_dates = weeks.map do |sessions|
      [sessions[0].start.time.to_date, sessions[-1].stop.time.to_date]
    end

    tot_sec = week_seconds.sum
    avg_sec = tot_sec / ((from - to + 1) / 7.0).ceil

    timeframe_html(from, to) +
      choice_html('WEEKLY DIGEST') +
      weekly_digest_content(week_dates, week_seconds) +
      summaries_html(avg_sec, tot_sec, 'per week')
  end

  def weekly_digest_content(week_dates, week_seconds)
    week_dates.zip(week_seconds).map do |(start_date, stop_date), seconds|
      <<~HTML
        <div class="summary">
          <span class="title">#{strfdate(start_date)} &ndash; #{strfdate(stop_date)}: </span>
          <span class="content">#{time_elapsed(seconds)}</span>
        </div>
      HTML
    end.join
  end
end
