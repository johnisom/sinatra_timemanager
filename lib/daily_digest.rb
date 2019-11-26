# frozen_string_literal: true

# Daily Digest viewing module
module DailyDigest
  private

  def daily_digest(from, to)
    days = sessions_in_timeframe(from, to).chunk do |session|
      session.start.time.day
    end.map(&:last)

    day_seconds = days.map do |sessions|
      sessions.sum(&:seconds)
    end

    content = daily_digest_content(days, day_seconds)

    tot_sec = day_seconds.sum
    avg_sec = tot_sec / (from - to + 1)

    timeframe_html(from, to) +
      choice_html('DAILY DIGEST') +
      content +
      summaries_html(avg_sec, tot_sec)
  end

  def daily_digest_content(days, day_seconds)
    day_seconds.map.with_index do |seconds, idx|
      <<~HTML
        <div class="summary">
          <span class="title">#{days[idx][0].start.time.to_date.strftime('%a %Y-%m-%d')}: </span>
          <span class="content">#{time_elapsed(seconds)}</span>
        </div>
      HTML
    end.join
  end
end
