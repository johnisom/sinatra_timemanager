# frozen_string_literal: true

require 'fileutils'
require 'pg'
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

  CURR_PATH = ENV['RACK_ENV'] == 'test' ? 'tmp' : '.'
  DATA_PATH = File.expand_path('data', CURR_PATH)

  attr_reader :sessions

  def initialize(name)
    @db = PG.connect(dbname: 'time_manager')
    @username = name.gsub(/\W/, '')
    # touchfile(@username)
    # @sessions = Psych.load_file(File.join(DATA_PATH, "#{@username}.yml"))
    @sessions = get_sessions(@username)
    @sessions = [] unless @sessions.instance_of?(Array)
  end

  def start(message: nil)
    unless last_session.complete?
      raise StartTwiceError, "Can't start twice in a row!"
    end

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

  def last_session
    @sessions.last || Session.new(start: Entry.new(nil), stop: Entry.new(nil))
  end

  private

  def update_file
    filepath = File.join(DATA_PATH, "#{@username}.yml")
    content = Psych.dump(@sessions)
    File.write(filepath, content)
  end

  def touchfile(name)
    Dir.mkdir(DATA_PATH) unless File.directory?(DATA_PATH)
    FileUtils.touch(File.join(DATA_PATH, "#{name}.yml"))
  end

  def get_sessions(username)
    @db.exec_params(<<~SQL, [username]).map do |tup|
        SELECT s.start_time, s.start_message,
               s.stop_time, s.stop_message
          FROM sessions AS s
               INNER JOIN users AS u
               ON u.id = s.user_id
         WHERE u.username = $1
         ORDER BY s.start_time ASC;
      SQL
      start_entry = Entry.new(tup['start_message'],
                              DateTime.parse(tup['start_time']))
      stop_entry = tup['stop_time'] &&
                   Entry.new(tup['stop_message'],
                             DateTime.parse(tup['stop_time']))
      Session.new(start: start_entry, stop: stop_entry)
    end
  end
end
