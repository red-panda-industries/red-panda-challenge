require 'active_support'
require 'discordrb'
require 'logger'
require 'pry' # for debugging

def autoload_directory(*relative_path_parts)
  source_files = File.join(__dir__, *relative_path_parts, '**', '*.rb')
  Dir[source_files].each do |file|
    require file
  end
end

autoload_directory '..', 'initializers'
autoload_directory 'models'
autoload_directory 'bots'
