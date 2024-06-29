require 'simplecov'
SimpleCov.start

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

test_log_file = File.open(File.join(__dir__, '..', 'var', 'log', 'test.log'), 'a')

redirect_output(test_log_file) do
  ENV['RAILS_ENV'] = 'test'
  require_relative '../config/environment'
end

RSpec.configure do |config|
  config.around do |example|
    redirect_output(test_log_file) do
      example.run
    end
  end
end
