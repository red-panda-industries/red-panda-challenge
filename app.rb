require 'discordrb'
require 'dotenv/load'
require 'pry'
require 'sqlite3'

logger = Logger.new($stdout)

logger.info 'Hello, world!'

binding.pry
