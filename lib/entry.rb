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
