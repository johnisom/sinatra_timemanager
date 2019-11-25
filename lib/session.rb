# frozen_string_literal: true

require_relative 'entry'
require_relative 'timeable'

# Session class that has a start and a stop
class Session
  include Timeable

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

  def start_html
    <<~HTML
      <div class="start">
        <span class="title">Start: </span>
        <span class="content">#{start.to_html}</span>
      </div>
    HTML
  end

  def stop_html
    <<~HTML
      <div class="stop">
        <span class="title">Stop: </span>
        <span class="content">#{stop.to_html}</span>
      </div>
    HTML
  end

  def session_html
    <<~HTML
      <div class="summary">
        <span class="title">Session Time: </span>
        <span class="content">#{time_elapsed(seconds)}</span>
      </div>
    HTML
  end
end
