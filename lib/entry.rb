# frozen_string_literal: true

require_relative 'timeable'

# Entry class with (optional) message and time
class Entry
  include Timeable

  attr_reader :message, :time

  def initialize(message)
    @time = Time.now
    @message = message
  end

  def to_s
    "#{strftime(time)} -> #{message}"
  end

  def to_html
    %(<span class="time">#{time_str}</span>) +
      %(<span class="message">#{message_str}</span>)
  end

  private

  def time_str
    strftime(time)
  end

  def message_str
    message ? " -> #{message}" : ''
    message && " -> #{message}" || ''
  end
end
