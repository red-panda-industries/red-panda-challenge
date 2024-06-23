class ApplicationBot
  DISCORD_INTENTS = %i(
    server_messages
    server_message_reactions
  )

  COMMAND_PREFIX = '!'
  COMMAND_HANDLERS = {}

  attr_reader :bot, :logger

  def initialize
    @bot = Discordrb::Commands::CommandBot.new(
      token:    ::ApplicationConfig.discord_bot_token,
      intents:  self.class.const_get(:DISCORD_INTENTS),
      prefix:   self.class.const_get(:COMMAND_PREFIX)
    )

    @logger = Logger.new($stdout, progname: self.class.name)

    register_commands!
  end

  def run!
    logger.info 'Starting...'
    logger.info "This bot's invite URL is #{bot.invite_url}"
    bot.run
  end

  private

  def register_commands!
    command_handlers = self.class.const_get(:COMMAND_HANDLERS)
    command_handlers.each do |command_name, handler_method_name|
      register_command!(command_name, handler_method_name)
    end
  end

  # Define a command handler method and register it with the bot with logging and error handling
  def register_command!(command_name, handler_method_name)
    logger.debug "Registering command: #{command_name} -> #{handler_method_name}"

    bot.command(command_name) do |event|
      begin
        logger.info "#{COMMAND_PREFIX}#{command_name} - #{event.user.name} (#{event.user.id}): #{event.message.content}"

        __send__(handler_method_name, event)
      rescue StandardError => error
        event << 'An error occurred while processing this command.'
        logger.error(error)
      ensure
        return nil # Prevent the command from echoing the return value
      end
    end
  end
end