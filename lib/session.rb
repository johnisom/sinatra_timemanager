# frozen_string_literal: true

require_relative 'entry'

# Session class that has a start and a stop
class Session
  attr_accessor :start
  attr_writer :stop

  def initialize(start:, stop: nil)
    @start = start
    @stop = stop
  end

  def complete?
    @start && @stop
  end

  def stop
    @stop || Entry.new('CURRENT')
  end

  def to_html
    start_html + stop_html + session_html
  end

  def seconds
    (stop.time - start.time).round
  end

  private

  def time_str
    sec = seconds
    hour = sec / 3600
    min = sec / 60 % 60
    sec = sec % 60
    format('%<hour>02d:%<min>02d:%<sec>02d', hour: hour, min: min, sec: sec)
  end

  def start_html
    %(<div class="start"><span class="title">Start: </span>) +
      %(<span class="content">#{start.to_html}</span></div>)
  end

  def stop_html
    %(<div class="stop"><span class="title">Stop: </span>) +
      %(<span class="content">#{stop.to_html}</span></div>)
  end

  def session_html
    %(<div class="session-time"><span class="title">Session Time: </span>)+
      %(<span class="content">#{time_str}</span></div>)
  end
end
