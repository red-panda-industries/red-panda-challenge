class ApplicationBot
  @@command_prefix = '!'
  @@command_handlers = {}

  attr_reader :bot, :logger

  def initialize
    @bot = Discordrb::Commands::CommandBot.new(
      token:    ::Application.discord_bot_token,
      prefix:   @@command_prefix,
    )
    @logger = Logger.new($stdout, progname: self.class.name)

    register_commands!
  end

  def run!
    logger.info 'Starting...'
    logger.info "Started: This bot's invite URL is #{bot.invite_url}"
    bot.run
  end

  private

  def register_commands!
    @@command_handlers.each do |command_name, handler_method_name|
      register_command!(command_name:, handler_method_name:)
    end
  end

  def register_command!(command_name:, handler_method_name:)
    logger.info "Registering command: #{@@command_prefix}#{command_name} -> #{self.class.name}##{handler_method_name}"

    bot.command(command_name) do |event|
      handle_command!(command_name:, handler_method_name:, event:)
      nil
    end
  end

  def handle_command!(command_name:, handler_method_name:, event:)
    logger.info "Message: #{event.message.content.inspect}"
    logger.info "↳ Handler: #{self.class.name}##{handler_method_name}"
    logger.info "↳ User: #{event.user.name.inspect} (#{event.user.id})"
    logger.info "↳ Server: #{event.server.name.inspect} (#{event.server.id})"
    logger.info "↳ Channel: #{event.channel.name.inspect} (#{event.channel.id})"

    begin
      __send__(handler_method_name, event)

    rescue StandardError => error
      event << 'An error occurred while processing this command.'
      logger.error(error)
    end
  end

end