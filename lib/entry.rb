# frozen_string_literal: true

# Entry class with (optional) message and time
class Entry
  attr_reader :message, :time

  def initialize(message)
    @time = Time.now
    @message = message
  end
end

# Pair class that has a start and a stop
class Pair
  attr_accessor :start, :stop

  def initialize(start:, stop: nil)
    @start = start
    @stop = stop
  end

  def complete?
    start && stop
  end
end
