# frozen_string_literal: true

require 'fileutils'
require 'yaml'

require_relative 'entry'
require_relative 'session'
require_relative 'viewable'

class StartTwiceError < StandardError
end

class StopTwiceError < StandardError
end

class MaxUndoError < StandardError
end

# Main app that handles everything
class TM
  include Viewable

  DATA_PATH = File.expand_path('./data')

  attr_reader :sessions
  
  def initialize(name)
    @username = name.gsub(/\W/, '')
    touchfile(@username)
    @sessions = Psych.load_file(File.join(DATA_PATH, "#{@username}.yml"))
    @sessions = [] unless @sessions.instance_of?(Array)
  end
  
  def start(message: nil)
    raise StartTwiceError, "Can't start twice in a row!" if !last_session.complete?
    
    @sessions << Session.new(start: Entry.new(message))

    update_file
  end

  def stop(message: nil)
    raise StopTwiceError, "Can't stop twice in a row!" if last_session.complete?

    last_session.stop = Entry.new(message)
    update_file
  end

  def undo
    raise MaxUndoError, "Can't undo any more!" if @sessions.empty?
      
    if last_session.complete?
      last_session.stop = nil
    else
      @sessions.pop
    end
    update_file
  end

  private

  def update_file
    filepath = File.join(DATA_PATH, "#{@username}.yml")
    content = Psych.dump(@sessions)
    File.write(filepath, content)
  end

  def last_session
    @sessions.last || Session.new(start: Entry.new(nil), stop: Entry.new(nil))
  end

  def touchfile(name)
    Dir.mkdir(DATA_PATH) unless File.directory?(DATA_PATH)
    FileUtils.touch(File.join(DATA_PATH, "#{name}.yml"))
  end
end
