require 'discordrb'
require 'dotenv/load'
require 'pry'
require 'sqlite3'

DISCORD_BOT_TOKEN = ENV['DISCORD_BOT_TOKEN'].to_s.strip
fail 'The environment variable DISCORD_BOT_TOKEN is not set' if DISCORD_BOT_TOKEN.empty?

logger = Logger.new($stdout)
logger.info 'Red Panda Challenge bot is starting...'

bot = Discordrb::Commands::CommandBot.new(
  token:    DISCORD_BOT_TOKEN,
  intents:  [:server_messages, :server_message_reactions],
  prefix:   '!',
)

logger.info 'Red Panda Challenge bot is running.'
logger.info "This bot's invite URL is #{bot.invite_url}"

################################################################

bot.message(content: 'Ping!') do |event|
  event << 'Pong!'
end

bot.command('user') do |event|
  event << "Your username is #{event.user.name}, and your ID is #{event.user.id}"
end

@counts = {}

bot.command('count') do |event|
  user_id = event.user.id
  @counts[user_id] ||= 0
  @counts[user_id] += 1
  event << "You have used this command #{@counts[user_id]} times now."
end

bot.run()
