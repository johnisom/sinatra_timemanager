# frozen_string_literal: true

class NoViewDataError < StandardError
end

class InvalidFiltersError < StandardError
end

# Viewable module to add view methods to TimeManager class
module Viewable
  SEC_IN_DAY = 24 * 60 * 60
  
  def view(timeframe_from, timeframe_to, view_option)
    raise NoViewDataError, "Can't view without any data!" if @pairs.empty?

    timeframe_from, timeframe_to = convert_timeframes(timeframe_from,
                                                      timeframe_to)

    if (error = error_for_timeframes(timeframe_from, timeframe_to))
      raise InvalidFiltersError, error
    end

    case view_option
    when 'default', nil   then        default(timeframe_from, timeframe_to)
    when 'daily-digest'   then   daily_digest(timeframe_from, timeframe_to)
    when 'day-delimited' then  day_delimited(timeframe_from, timeframe_to)
    when 'weekly-digest'  then  weekly_digest(timeframe_from, timeframe_to)
    when 'week-delimited' then week_delimited(timeframe_from, timeframe_to)
    else                raise InvalidFiltersError, "View option not valid."
    end
  end

  private

  def default(timeframe_from, timeframe_to)
    from_idx = timeframe_from >= days.size ? 0 : -(timeframe_from + 1)
    to_idx = -(timeframe_to + 1)
    days[from_idx..to_idx].flatten.map do |pair|
      %(<div class="session">#{pair.to_html}</div>)
    end.join
  end

  def daily_digest(timeframe_from, timeframe_to); end

  def day_delimited(timeframe_from, timeframe_to); end

  def weekly_digest(timeframe_from, timeframe_to); end

  def week_delimited(timeframe_from, timeframe_to); end

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
    (Time.now.to_date - @pairs.first.start.time.to_date + 1).to_i
  end

  def days
    @pairs.chunk do |pair|
      pair.start.time.day
    end.map(&:last)
  end
end
