require 'discordrb'
require 'dotenv/load'
require 'pry'
require 'sqlite3'

logger = Logger.new($stdout)

logger.info 'Red Panda Challenge Bot is starting...'

bot = Discordrb::Commands::CommandBot.new(
  token: ENV['DISCORD_BOT_TOKEN'],
  intents: [:server_messages],
  prefix: '!',
)

logger.info 'Red Panda Challenge is running.'
logger.info "This bot's invite URL is #{bot.invite_url}"

bot.message(content: 'Ping!') do |event|
  event.respond 'Pong!'
end

bot.command(:user) do |event|
  event.respond event.user.name
end

bot.run()
