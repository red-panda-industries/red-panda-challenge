class RedPandaChallengeBot
  DISCORD_INTENTS = %i(
    server_messages
    server_message_reactions
  ).freeze

  COMMAND_PREFIX = '!'

  COMMAND_HANDLERS = {
    :user     => :handle_user_info!,
    :count    => :handle_count!,
    :michelle => :handle_michelle!,
  }.freeze

  attr_reader :bot, :logger

  def initialize
    @bot = Discordrb::Commands::CommandBot.new(
      token:    ::ApplicationConfig.discord_bot_token,
      intents:  DISCORD_INTENTS,
      prefix:   COMMAND_PREFIX,
    )

    @logger = Logger.new(
      $stdout,
      progname: self.class.name
    )

    register_commands!
  end

  def run!
    logger.info 'Starting...'
    logger.info "This bot's invite URL is #{bot.invite_url}"
    bot.run
  end

  private

  def register_commands!
    COMMAND_HANDLERS.each do |command_name, handler_method_name|
      register_command!(command_name, handler_method_name)
    end
  end

  def register_command!(command_name, handler_method_name)
    logger.debug "Registering command: #{command_name} -> #{handler_method_name}"

    bot.command(command_name) do |event|
      logger.info "#{event.user.name} (#{event.user.id}): #{event.message.content}"
      __send__(handler_method_name, event)
    end
  end

  ################################################################

  def handle_user_info!(event)
    user = User.from_discord_event(event)
    event << "Your username is #{user.username} and your Discord ID is #{user.discord_id}."
    event << "Your count is #{user.count}. Your created at is #{user.created_at}. Your updated at is #{user.updated_at}."
  end

  def handle_count!(event)
    user = User.from_discord_event(event)
    user.count += 1
    user.save!
    event << "You have used this command #{user.count} times now."
  end

  def handle_michelle!(event)
    user = User.from_discord_event(event)
    if user.has_completed_michelle_obama_challenge_today?
      event << 'You have already completed the Michelle Obama challenge today.'
    else
      user.complete_michelle_obama_challenge!
      event << 'You have completed the Michelle Obama challenge for today!'
    end
    event << "You have completed the Michelle Obama challenge #{user.michelle_obama_challenge_entries.count} times."
  end
end
