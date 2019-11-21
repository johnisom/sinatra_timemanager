# frozen_string_literal: true

class NoViewDataError < StandardError
end

# Viewable module to add view methods to TimeManager class
module Viewable
  def view(timeframe_from, timeframe_to, view_option)
    raise NoViewDataError, "Can't view without any data!" if @pairs.empty?

    case view_option
    when 'default'        then        default(timeframe_from, timeframe_to)
    when 'daily-digest'   then   daily_digest(timeframe_from, timeframe_to)
    when 'day-delimimted' then  day_delimited(timeframe_from, timeframe_to)
    when 'weekly-digest'  then  weekly_digest(timeframe_from, timeframe_to)
    when 'week-delimited' then week_delimited(timeframe_from, timeframe_to)
    end
  end

  private

  def default(timeframe_from, timeframe_to)
    @pairs.map do |pair|
      "Start: #{pair.start}\nStop: #{pair.stop}"
    end.join("\n\n")
  end

  def daily_digest(timeframe_from, timeframe_to); end

  def day_delimited(timeframe_from, timeframe_to); end

  def weekly_digest(timeframe_from, timeframe_to); end

  def week_delimited(timeframe_from, timeframe_to); end
end
