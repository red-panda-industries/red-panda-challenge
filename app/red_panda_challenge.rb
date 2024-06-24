# This file loads the entire application but doesn't start anything.

require 'active_record'
require 'active_support'
require 'discordrb'
require 'dotenv/load'
require 'logger'
require 'pry'
require 'sqlite3'
require 'yaml'

def autoload_directory!(*relative_path_parts)
  source_files = File.join(__dir__, *relative_path_parts, '**', '*.rb')
  Dir[source_files].each do |file|
    require file
  end
end

autoload_directory! '..', 'config'
autoload_directory! '..', 'initializers'
autoload_directory! 'helpers'
autoload_directory! 'models'
autoload_directory! 'bots'
