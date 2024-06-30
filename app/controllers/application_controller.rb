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
    @logger ||= Logger.new($stdout, progname: self.class.name)
  end
end
