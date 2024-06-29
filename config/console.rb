# Prelude for the application console

require 'factory_bot'

FactoryBot.definition_file_paths = [File.join(__dir__, '..', 'spec', 'factories')]
FactoryBot.find_definitions

include FactoryBot::Syntax::Methods
