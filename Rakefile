require 'active_record'
require 'active_support'
require 'dotenv/load'
require 'rake'
require 'yaml'

ENVIRONMENT = ENV['RAILS_ENV'].presence || 'development'

DB_CONFIG_PATH = File.join(__dir__, 'config/database.yml')
DB_MIGRATIONS_PATH = File.join(__dir__, 'db/migrate')

DATABASE_CONFIG = YAML.load_file(DB_CONFIG_PATH)[ENVIRONMENT]
fail "Database configuration for '#{ENVIRONMENT}' not found in '#{DB_CONFIG_PATH}'" if DATABASE_CONFIG.nil?

DATABASE_FILENAME = File.join(__dir__, DATABASE_CONFIG['database'])
DATABASE_DIR = File.dirname(DATABASE_FILENAME)

ActiveRecord::Base.logger = Logger.new($stdout)

namespace :db do
  desc 'Create the database'
  task :create do
    if File.exist?(DATABASE_FILENAME)
      puts "Database '#{DATABASE_FILENAME}' already exists"
      next
    end

    puts "Creating database '#{DATABASE_FILENAME}'"
    FileUtils.mkdir_p(DATABASE_DIR) unless Dir.exist?(DATABASE_DIR)
    ActiveRecord::Base.establish_connection(DATABASE_CONFIG)
    ActiveRecord::Base.connection # This will create the SQLite file
  end

  desc 'Drop the database'
  task :drop do
    if File.exist?(DATABASE_FILENAME)
      puts "Dropping database '#{DATABASE_FILENAME}'"
      File.delete(DATABASE_FILENAME)
    else
      puts "Database '#{DATABASE_FILENAME}' does not exist"
    end
  end

  desc 'Migrate the database'
  task :migrate do
    ActiveRecord::Base.establish_connection(DATABASE_CONFIG)
    ActiveRecord::Migrator.migrations_paths = [DB_MIGRATIONS_PATH]
    ActiveRecord::MigrationContext.new(ActiveRecord::Migrator.migrations_paths).migrate
  end

  desc 'Rollback the last migration'
  task :rollback do
    ActiveRecord::Base.establish_connection(DATABASE_CONFIG)
    ActiveRecord::Migrator.migrations_paths = [DB_MIGRATIONS_PATH]
    ActiveRecord::MigrationContext.new(ActiveRecord::Migrator.migrations_paths).rollback
  end

  desc 'Create and migrate the database'
  task :setup => [:create, :migrate]

  desc 'Reset the database'
  task :reset => [:drop, :create, :migrate]
end

desc 'Run all of the tests'
task :test do
  test_files = File.join(__dir__, 'spec', '**', '*_spec.rb')
  Dir[test_files].each do |file|
    system 'bundle', 'exec', 'ruby', file
  end
end
