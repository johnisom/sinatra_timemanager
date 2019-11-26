# frozen_string_literal: true

# Day Delimited viewing module
module DayDelimited
  private

  def day_delimited(from, to)
    days = days(from, to).map
    day_seconds = days.map { |sessions| sessions.sum(&:seconds) }

    tot_sec = day_seconds.sum
    avg_sec = tot_sec / (from - to + 1)

    content = days.zip(day_seconds).map do |sessions, seconds|
      sessions.map do |session|
        %(<div class="session">#{session.to_html}</div>)
      end.join + day_delimiter(seconds)
    end.join

    timeframe_html(from, to) +
      choice_html('DAY DELIMITED') +
      content +
      summaries_html(avg_sec, tot_sec)
  end

  def day_delimiter(seconds)
    <<~HTML
      <div class="delimiter">
        <div class="line">#{'=' * 150}</div>
        <div class="summary">
          <span class="title">Daily amount: </span>
          <span class="content">#{time_elapsed(seconds)}</span>
        </div>
        <div class="line">#{'=' * 150}</div>
      </div>
    HTML
  end
end
