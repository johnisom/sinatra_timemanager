# frozen_string_literal: true

# Timeable module for dealing with timeable stuff
module Timeable
  private

  def hour_min_sec(seconds)
    sec = seconds % 60
    min = seconds / 60 % 60
    hour = seconds / 3600
    [hour, min, sec]
  end

  def time_elapsed(seconds)
    hour, min, sec = hour_min_sec(seconds)
    format('%<hour>02d:%<min>02d:%<sec>02d', hour: hour, min: min, sec: sec)
  end

  def strfdate(date)
    date.strftime('%a %Y-%m-%d')
  end

  def strftime(time)
    time.strftime('%a %Y-%m-%d %H:%M:%S')
  end
end
