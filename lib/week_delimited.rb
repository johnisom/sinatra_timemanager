# frozen_string_literal: true

require_relative 'timeable'

# Week Delimited viewing module
module WeekDelimited
  private

  include Timeable

  def week_delimited(from, to)
    weeks_days, weeks_days_seconds, weeks_seconds = week_data(from, to)
    all_zipped = weeks_days.zip(weeks_days_seconds, weeks_seconds)

    tot_sec = weeks_days_seconds.sum(&:sum)
    avg_sec = begin tot_sec / weeks_days.size
              rescue ZeroDivisionError; 0
              end

    timeframe_html(from, to) +
      choice_html('WEEK DELIMITED') +
      week_delimited_content(all_zipped) +
      summaries_html(avg_sec, tot_sec, 'per logged week')
  end

  def week_data(from, to)
    weeks_days = weeks(from, to).map do |sessions|
      sessions.chunk { |session| session.start.time.day }.map(&:last)
    end

    weeks_days_seconds = weeks_days.map do |days|
      days.map { |sessions| sessions.sum(&:seconds) }
    end

    weeks_seconds = weeks_days_seconds.map(&:sum)

    [weeks_days, weeks_days_seconds, weeks_seconds]
  end

  def week_delimiter(seconds)
    <<~HTML
      <div class="delimiter">
        <div class="line">#{'=' * 150}</div>
        <div class="summary">
          <span class="title">Weekly amount: </span>
          <span class="content">#{time_elapsed(seconds)}</span>
        </div>
        <div class="line">#{'=' * 150}</div>
      </div>
    HTML
  end

  def week_delimited_content(all_zipped)
    all_zipped.map do |days, days_seconds, weekly_seconds|
      days.zip(days_seconds).map do |sessions, daily_seconds|
        <<~HTML
          <div class="summary">
            <span class="title">#{strfdate(sessions[0].start.time.to_date)}</span>
            <span class="content">#{time_elapsed(daily_seconds)}</span>
          </div>
        HTML
      end.join + week_delimiter(weekly_seconds)
    end.join
  end
end
