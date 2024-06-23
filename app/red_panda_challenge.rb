require 'active_support'
require 'discordrb'
require 'logger'
require 'pry' # for debugging

# Autoload initializers from the app/initializers directory

Dir[File.join(__dir__, '..', 'initializers', '*.rb')].each do |file|
  require file
end

# Autoload models from the app/models directory

Dir[File.join(__dir__, 'models', '*.rb')].each do |file|
  require file
end

# Autoload bots from the app/bots directory

Dir[File.join(__dir__, 'bots', '*.rb')].each do |file|
  require file
end
