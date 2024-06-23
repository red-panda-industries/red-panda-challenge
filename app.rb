require 'active_record'
require 'active_support'
require 'discordrb'
require 'dotenv/load'
require 'pry'
require 'sqlite3'
require 'yaml'

################################################################

module Environment
  DEFAULT_ENVIRONMENT_NAME = 'development'
  ENVIRONMENT_NAME = ENV.fetch('RAILS_ENV', DEFAULT_ENVIRONMENT_NAME).strip.downcase

  def self.development?
    ENVIRONMENT_NAME == 'development'
  end

  def self.name
    ENVIRONMENT_NAME
  end
end

module ApplicationConfig
  def self.discord_bot_token
    ENV.fetch('DISCORD_BOT_TOKEN') do abort 'The environment variable DISCORD_BOT_TOKEN is not set' end
  end

  def self.database_config
    @_database_config ||= load_database_config
  end

  private
  
  def self.load_database_config
    config_file = File.join(__dir__, 'config/database.yml')
    config_yaml = YAML.load_file(config_file) rescue (abort "Failed to load or parse '#{config_file}'")
    config_yaml[Environment.name] or abort "Database configuration for '#{Environment.name}' not found in '#{config_file}'"
  end
end

################################################################

ActiveRecord::Base.logger = Logger.new($stdout)
ActiveRecord::Base.establish_connection(ApplicationConfig.database_config)

at_exit do
  ActiveRecord::Base.connection.close
end

unless ActiveRecord::Base.connection.table_exists?('schema_migrations')
  abort 'The database file does not exist. Run "rake db:setup" to set up the database'
end

if ActiveRecord::Base.connection.migration_context.needs_migration?
  abort 'You have database migrations that need to be run. Run "rake db:migrate" to update the database schema.'
end

# Autoload models from the app/models directory

Dir[File.join(__dir__, 'app/models', '*.rb')].each do |file|
  require file
end

################################################################

logger = Logger.new($stdout)

# @param [Discordrb::Events::MessageEvent] event
def logger.event(event)
  self.info "#{event.user.name} (#{event.user.id}): #{event.message.content}"
end

################################################################

logger.info 'Red Panda Challenge bot is starting...'

bot = Discordrb::Commands::CommandBot.new(
  token:    ApplicationConfig.discord_bot_token,
  intents:  %i(server_messages server_message_reactions),
  prefix:   '!',
)

logger.info 'Red Panda Challenge bot is running.'
logger.info "This bot's invite URL is #{bot.invite_url}"

################################################################

bot.message(content: 'Ping!') do |event|
  logger.event(event)
  user = User.from_discord_event(event)

  event << 'Pong!'
end

bot.command(:user) do |event|
  logger.event(event)
  user = User.from_discord_event(event)

  event << "Your username is #{user.username} and your Discord ID is #{user.discord_id}."
  event << "Your count is #{user.count}. Your created at is #{user.created_at}. Your updated at is #{user.updated_at}."
end

bot.command(:count) do |event|
  logger.event(event)
  user = User.from_discord_event(event)
  
  user.count += 1
  user.save!

  event << "You have used this command #{user.count} times now."
end

bot.command(:michelle) do |event|
  logger.event(event)
  user = User.from_discord_event(event)

  if user.has_completed_michelle_obama_challenge_today?
    event << 'You have already completed the Michelle Obama challenge today.'
  else
    user.complete_michelle_obama_challenge!
    event << 'You have completed the Michelle Obama challenge for today!'
  end

  event << "You have completed the Michelle Obama challenge #{user.michelle_obama_challenge_entries.count} times."
end

################################################################

bot.run()
