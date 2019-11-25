# frozen_string_literal: true

# Default viewing module
module Default
  private

  def default(timeframe_from, timeframe_to)
    sessions = sessions_in_timeframe(timeframe_from, timeframe_to)
    content = sessions.map do |session|
      %(<div class="session">#{session.to_html}</div>)
    end.join

    tot_sec = sessions.sum(&:seconds)
    avg_sec = tot_sec / (timeframe_from - timeframe_to + 1)

    timeframe_html(timeframe_from, timeframe_to) +
      choice_html('DEFAULT') +
      content +
      summaries_html(avg_sec, tot_sec)
  end
end
