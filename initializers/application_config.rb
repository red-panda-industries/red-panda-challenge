require 'dotenv/load'
require 'yaml'

require_relative 'environment'

module ApplicationConfig
  def self.database_config
    @_database_config ||= load_database_config
  end

  def self.discord_bot_token
    ENV.fetch('DISCORD_BOT_TOKEN') do abort 'The environment variable DISCORD_BOT_TOKEN is not set' end
  end

  private

  def self.load_database_config
    config_file = File.join(__dir__, '..', 'config', 'database.yml')
    config_yaml = YAML.load_file(config_file) rescue (abort "Failed to load or parse '#{config_file}'")
    config_yaml[Environment.name] or abort "Database configuration for '#{Environment.name}' not found in '#{config_file}'"
  end
end