require 'dotenv/load'
require 'pathname'
require 'yaml'

module Application
  DEFAULT_ENVIRONMENT_NAME = 'development'
  ENVIRONMENT_NAME = ENV.fetch('RAILS_ENV', DEFAULT_ENVIRONMENT_NAME).strip.downcase

  def self.environment
    ENVIRONMENT_NAME
  end
  
  def self.discord_bot_token
    ENV.fetch('DISCORD_BOT_TOKEN').presence || fail('The environment variable DISCORD_BOT_TOKEN is not set')
  end

  def self.database_filename
    database_config['database'].presence || fail('Database configuration does not specify a database filename')
  end

  def self.database_config
    all_database_config[environment].presence || fail("Database configuration for environment '#{environment}' not found")
  end

  def self.all_database_config
    @_all_database_config ||= load_all_database_config
  end

  def self.database_config_file
    path.join('config', 'database.yml')
  end

  def self.database_migrations_path
    path.join('db', 'migrate')
  end

  def self.db_schema_filename
    path.join('db', 'schema.rb')
  end

  def self.sounds_directory
    path.join('app', 'sounds')
  end

  def self.path(*parts)
    Pathname.new(File.expand_path(File.join(__dir__, '..')))
  end

  private

  def self.load_all_database_config
    begin
      YAML.load_file(database_config_file)
    rescue StandardError => e
      raise "Failed to load or parse '#{config_file}: #{e.message}'"
    end
  end
end
