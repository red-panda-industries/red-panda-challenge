# Start the code coverage tool.
require 'simplecov'
SimpleCov.start

# Load the gem dependencies.
require 'bundler/setup'
Bundler.require(:default, :test)

# Helper method to redirect stdout and stderr to a given IO object.
def redirect_output(writer = StringIO.new)
  original_stdout = $stdout
  original_stderr = $stderr
  $stdout = writer
  $stderr = writer
  begin
    yield
  ensure
    $stdout = original_stdout
    $stderr = original_stderr
  end
end

# We'll store test logs in a text file to keep the test output clean.
test_log_file = File.open(File.join(__dir__, '..', 'var', 'log', 'test.log'), 'a')

# Load the application in the test environment.
redirect_output(test_log_file) do
  ENV['RAILS_ENV'] = 'test'
  require_relative '../config/environment'
end

RSpec.configure do |config|
  config.around do |example|
    # Redirect stdout and stderr to the test log file for each example.
    redirect_output(test_log_file) do
      example.run
    end
  end

  config.include FactoryBot::Syntax::Methods
end

FactoryBot.definition_file_paths = [File.join(__dir__, 'factories.rb')]
FactoryBot.find_definitions
