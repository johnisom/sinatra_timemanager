# frozen_string_literal: true

require 'fileutils'

require_relative 'entry'
require_relative 'view'

class StartTwiceError < StandardError
end

class StopTwiceError < StandardError
end

class MaxUndoError < StandardError
end

# Main app that handles everything
class TimeManager
  include Viewable

  DATA_PATH = File.expand_path('./data')

  attr_reader :pairs
  
  def initialize(name)
    @username = name.gsub(/\W/, '')
    touchfile(@username)
    @pairs = Psych.load_file(File.join(DATA_PATH, "#{@username}.yml"))
    @pairs = [] unless @pairs.instance_of?(Array)
  end
  
  def start(message: nil)
    raise StartTwiceError, "Can't start twice in a row!" if !last_pair.complete?
    
    @pairs << Pair.new(start: Entry.new(message))

    update_file
  end

  def stop(message: nil)
    raise StopTwiceError, "Can't stop twice in a row!" if last_pair.complete?

    last_pair.stop = Entry.new(message)
    update_file
  end

  def undo
    raise MaxUndoError, "Can't undo any more!" if @pairs.empty?
      
    if last_pair.complete?
      last_pair.stop = nil
    else
      @pairs.pop
    end
  end

  private

  def update_file
    filepath = File.join(DATA_PATH, "#{@username}.yml")
    content = Psych.dump(@pairs)
    File.write(filepath, content)
  end

  def last_pair
    @pairs.last || Pair.new(start: Entry.new(nil), stop: Entry.new(nil))
  end

  def touchfile(name)
    Dir.mkdir(DATA_PATH) unless File.directory?(DATA_PATH)
    FileUtils.touch(File.join(DATA_PATH, "#{name}.yml"))
  end
end
