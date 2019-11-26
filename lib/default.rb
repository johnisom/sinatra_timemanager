# frozen_string_literal: true

# Default viewing module
module Default
  private

  def default(from, to)
    sessions = sessions_in_timeframe(from, to)
    content = sessions.map do |session|
      %(<div class="session">#{session.to_html}</div>)
    end.join

    tot_sec = sessions.sum(&:seconds)
    avg_sec = tot_sec / (from - to + 1)

    timeframe_html(from, to) +
      choice_html('DEFAULT') +
      content +
      summaries_html(avg_sec, tot_sec, 'per day within timeframe')
  end
end
