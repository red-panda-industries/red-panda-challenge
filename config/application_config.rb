module ApplicationConfig
  DEFAULT_ENVIRONMENT_NAME = 'development'
  ENVIRONMENT_NAME = ENV.fetch('RAILS_ENV', DEFAULT_ENVIRONMENT_NAME).strip.downcase

  def self.environment
    ENVIRONMENT_NAME
  end

  def self.development?
    environment == 'development'
  end

  def self.discord_bot_token
    ENV.fetch('DISCORD_BOT_TOKEN') do abort 'The environment variable DISCORD_BOT_TOKEN is not set' end
  end

  def self.database_config
    @_database_config ||= load_database_config
  end

  private

  def self.load_database_config
    config_file = File.join(__dir__, '..', 'config', 'database.yml')
    config_yaml = YAML.load_file(config_file) rescue (abort "Failed to load or parse '#{config_file}'")
    config_yaml[environment] or abort "Database configuration for '#{environment}' not found in '#{config_file}'"
  end
end