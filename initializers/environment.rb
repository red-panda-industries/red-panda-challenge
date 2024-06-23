require 'dotenv/load'

module Environment
  DEFAULT_ENVIRONMENT_NAME = 'development'
  ENVIRONMENT_NAME = ENV.fetch('RAILS_ENV', DEFAULT_ENVIRONMENT_NAME).strip.downcase

  def self.development?
    ENVIRONMENT_NAME == 'development'
  end

  def self.name
    ENVIRONMENT_NAME
  end
end