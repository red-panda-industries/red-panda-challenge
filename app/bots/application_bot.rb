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
      intents:  discord_intents,
      prefix:   command_prefix,
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

  # Load the constants from the class or child class
  def discord_intents() = self.class.const_get(:DISCORD_INTENTS)
  def command_prefix() = self.class.const_get(:COMMAND_PREFIX)
  def command_handlers() = self.class.const_get(:COMMAND_HANDLERS)

  def register_commands!
    command_handlers.each do |command_name, handler_method_name|
      register_command!(command_name, handler_method_name)
    end
  end

  def register_command!(command_name, handler_method_name)
    logger.info "Registering command: #{command_prefix}#{command_name} -> #{self.class.name}##{handler_method_name}"

    bot.command(command_name) do |event|
      begin
        logger.info "##{handler_method_name} invoked by #{event.user.name} (#{event.user.id}) with message: #{event.message.content.inspect}"

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