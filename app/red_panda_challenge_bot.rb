class RedPandaChallengeBot
  attr_reader :bot, :logger, :command_prefix

  def initialize(command_prefix: '!')
    @command_prefix = command_prefix

    @bot = Discordrb::Commands::CommandBot.new(
      token:    ::Application.discord_bot_token,
      prefix:   command_prefix,
    )

    @logger = Logger.new($stdout, progname: self.class.name)

    register_commands!
  end

  def run!
    logger.info 'Starting...'
    invite_url = bot.invite_url
    logger.info 'Started.'
    logger.info "\e[1m\e[32mThis bot's invite URL is \033[4m#{bot.invite_url}\e[0m"
    bot.run
  end

  private

  def register_commands!
    COMMANDS.each do |command_name, (controller_name, method_name)|
      register_command!(command_name:, controller_name:, method_name:)
    end
  end

  def register_command!(command_name:, controller_name:, method_name:)
    logger.info "Registering command: #{command_prefix}#{command_name} -> #{controller_name}##{method_name}"

    bot.command(command_name) do |event|
      run_action!(controller_name:, method_name:, event:)
      nil
    end
  end

  def run_action!(controller_name:, method_name:, event:)
    logger.info "Message: \e[1m\e[32m#{event.message.content.inspect}\e[0m"
    logger.info "↳ User: #{event.user.name.inspect} (#{event.user.id})"
    logger.info "↳ Server: #{event.server.name.inspect} (#{event.server.id})"
    logger.info "↳ Channel: #{event.channel.name.inspect} (#{event.channel.id})"
    logger.info "↳ Handler: #{controller_name}##{method_name}"

    begin
      controller = Object.const_get(controller_name).new(event:, bot:)
      controller.__send__(method_name)

    rescue StandardError => error
      event << 'An error occurred while processing this command.'
      logger.error(error)
    end
  end

end