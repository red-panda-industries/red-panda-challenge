class ApplicationController
  attr_reader :event, :bot

  def initialize(event:, bot:)
    @event = event
    @bot = bot
  end

  def user
    @user ||= User.from_discord_event(event)
  end

  def logger
    # Log the user, server, and channel for each log message
    @logger_formatter ||= proc do |severity, datetime, progname, msg|
      event_data = { user: event.user.name, user_id: event.user.id, server: event.server.name, server_id: event.server.id, channel: event.channel.name, channel_id: event.channel.id }

      "#{severity.upcase[0]}, [#{datetime.strftime('%Y-%m-%dT%H:%M:%S.%6N')} ##{Process.pid}] #{severity.rjust(5)} -- #{progname}: #{msg} #{event_data.inspect}\n"
    end

    @logger ||= Logger.new($stdout, progname: self.class.name, formatter: @logger_formatter)
  end
end
