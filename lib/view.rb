# frozen_string_literal: true

class NoViewDataError < StandardError
end

# Viewable module to add view methods to TimeManager class
module Viewable
  def view
    raise NoViewDataError, "Can't view without any data!" if @pairs.empty?

    @pairs.map do |pair|
      "Start: #{pair.start}\nStop: #{pair.stop}"
    end.join("\n\n")
  end
end
