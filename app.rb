require 'active_record'
require 'active_support'
require 'discordrb'
require 'dotenv/load'
require 'pry'
require 'sqlite3'
require 'yaml'

################################################################

ENVIRONMENT = ENV['RAILS_ENV'].presence || 'development'

DB_CONFIG_PATH = File.join(__dir__, 'config/database.yml')

DATABASE_CONFIG = YAML.load_file(DB_CONFIG_PATH)[ENVIRONMENT]
abort "Database configuration for '#{ENVIRONMENT}' not found in '#{DB_CONFIG_PATH}'" if DATABASE_CONFIG.blank?

DISCORD_BOT_TOKEN = ENV['DISCORD_BOT_TOKEN']
abort 'The environment variable DISCORD_BOT_TOKEN is not set' if DISCORD_BOT_TOKEN.blank?

$logger = Logger.new($stdout)

################################################################

ActiveRecord::Base.logger = $logger
ActiveRecord::Base.establish_connection(DATABASE_CONFIG)

at_exit do
  ActiveRecord::Base.connection.close
end

unless ActiveRecord::Base.connection.table_exists?('schema_migrations')
  abort "The database file does not exist. Run 'rake db:setup' to set up the database"
end

if ActiveRecord::Base.connection.migration_context.needs_migration?
  abort "You have database migrations that need to be run. Run 'rake db:migrate' to update the database schema."
end

# Autoload models from the app/models directory

Dir[File.join(__dir__, 'app/models', '*.rb')].each do |file|
  require file
end

################################################################

$logger.info 'Red Panda Challenge bot is starting...'

bot = Discordrb::Commands::CommandBot.new(
  token:    DISCORD_BOT_TOKEN,
  intents:  %i(server_messages server_message_reactions),
  prefix:   '!',
)

$logger.info 'Red Panda Challenge bot is running.'
$logger.info "This bot's invite URL is #{bot.invite_url}"

################################################################

bot.message(content: 'Ping!') do |event|
  event << 'Pong!'
end

bot.command('user') do |event|
  event << "Your username is #{event.user.name}, and your ID is #{event.user.id}"
end

bot.command('count') do |event|
  user = User.from_discord_event(event)
  
  $logger.info "User #{user} used the count command."

  user.count += 1
  user.save!

  event << "You have used this command #{user.count} times now."
end

################################################################

bot.run()
