# Red Panda Challenge

# This file loads the entire application.
# See `bin/server.rb` for the entry point to the application.
# See `spec/` for the tests.

# Load all of the gem dependencies.
require 'bundler/setup'
Bundler.require(:default)

# Require all files in the given directory.
def require_relative_directory(*relative_path_parts)
  source_files = File.join(__dir__, *relative_path_parts, '**', '*.rb')
  Dir[source_files].each do |file|
    require file
  end
end

# Load the application.
require_relative 'application'
require_relative 'commands'
require_relative_directory 'initializers'
require_relative_directory '..', 'app', 'helpers'
require_relative_directory '..', 'app', 'views'
require_relative_directory '..', 'app', 'models'
require_relative_directory '..', 'app', 'controllers'
require_relative '../app/red_panda_challenge_bot'
