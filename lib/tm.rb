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

  attr_reader :sessions

  def initialize(name)
    @db = if Sinatra::Base.production?
            PG.connect(ENV['DATABASE_URL'])
          else
            PG.connect(dbname: 'time_manager')
          end
    @username = name.gsub(/\W/, '')
    # require 'pry';binding.pry
    @user_id = @db.exec_params(<<~SQL, [@username]).first['id'].to_i
      SELECT id
        FROM users
       WHERE username = $1;
    SQL
    @sessions = get_sessions
  end

  def start(message: nil)
    unless last_session.complete?
      raise StartTwiceError, "Can't start twice in a row!"
    end

    @sessions << Session.new(start: Entry.new(message))

    @db.exec_params(<<~SQL, [message, @user_id])
      INSERT INTO sessions (start_message, user_id, stop_time)
      VALUES ($1, $2, NULL);
    SQL
  end

  def stop(message: nil)
    raise StopTwiceError, "Can't stop twice in a row!" if last_session.complete?

    last_session.stop = Entry.new(message)

    @db.exec_params(<<~SQL, [message, @user_id])
      UPDATE sessions
         SET stop_message = $1,
             stop_time = DEFAULT
       WHERE user_id = $2
             AND id =
             (SELECT id
                FROM sessions
               ORDER BY start_time DESC
               LIMIT 1);
    SQL
  end

  def undo
    raise MaxUndoError, "Can't undo any more!" if @sessions.empty?

    if last_session.complete?
      last_session.stop = nil
      @db.exec(<<~SQL)
        UPDATE sessions
           SET stop_time = NULL,
               stop_message = NULL
         WHERE id =
               (SELECT id
                  FROM sessions
                 ORDER BY start_time DESC
                 LIMIT 1);
      SQL
    else
      @sessions.pop
      @db.exec(<<~SQL)
        DELETE FROM sessions
         WHERE id =
               (SELECT id
                  FROM sessions
                 ORDER BY start_time DESC
                 LIMIT 1);
      SQL
    end
  end

  def last_session
    @sessions.last || Session.new(start: Entry.new(nil), stop: Entry.new(nil))
  end

  private

  def get_sessions
    @db.exec_params(<<~SQL, [@user_id]).map do |tup|
      SELECT s.start_time, s.start_message,
             s.stop_time, s.stop_message
        FROM sessions AS s
             INNER JOIN users AS u
             ON u.id = s.user_id
       WHERE u.id = $1
       ORDER BY s.start_time ASC;
    SQL
      start_entry = Entry.new(tup['start_message'],
                              Time.parse(tup['start_time']))
      stop_entry = tup['stop_time'] &&
                   Entry.new(tup['stop_message'],
                             Time.parse(tup['stop_time']))
      Session.new(start: start_entry, stop: stop_entry)
    end
  end
end
