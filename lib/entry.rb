# frozen_string_literal: true

# Entry class with (optional) message and time
class Entry
  attr_reader :message, :time

  def initialize(message)
    @time = Time.now
    @message = message
  end

  def to_s
    "#{time.strftime('%a %Y-%m-%d %H:%M:%S')} -> #{message}"
  end

  def to_html
    %(<span class="time">#{time_str}</span>) +
      %(<span class="message">#{message_str}</span>)
  end

  private

  def time_str
    time.strftime('%a %Y-%m-%d %H:%M:%S')
  end

  def message_str
    message ? " -> #{message}" : ''
    message && " -> #{message}" || ''
  end
end

# Pair class that has a start and a stop
class Pair
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

  def session_time
    sec = (stop.time - start.time).to_i
    hour = sec / 3600
    min = sec / 60 % 60
    sec = sec % 60
    format('%<hour>02d:%<min>02d:%<sec>02d', hour: hour, min: min, sec: sec)
  end

  private

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
      %(<span class="content">#{session_time}</span></div>)
  end
end
