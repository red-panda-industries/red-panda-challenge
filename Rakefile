namespace :db do
  desc 'Create the database'
  task :create => :load_database_settings do
    if File.exist?(ApplicationConfig.database_filename)
      puts "Database '#{ApplicationConfig.database_filename}' already exists"
      next
    end

    puts "Creating database '#{ApplicationConfig.database_filename}'"
    database_dirname = File.dirname(ApplicationConfig.database_filename)
    FileUtils.mkdir_p(database_dirname) unless Dir.exist?(database_dirname)
    ActiveRecord::Base.establish_connection(ApplicationConfig.database_config)
    ActiveRecord::Base.connection # This will create the SQLite file
  end

  desc 'Drop the database'
  task :drop => :load_database_settings do
    if File.exist?(ApplicationConfig.database_filename)
      puts "Dropping database '#{ApplicationConfig.database_filename}'"
      File.delete(ApplicationConfig.database_filename)
    else
      puts "Database '#{ApplicationConfig.database_filename}' does not exist"
    end
  end

  desc 'Migrate the database'
  task :migrate => [:load_migrations, :load_database_settings] do
    ActiveRecord::MigrationContext.new(ActiveRecord::Migrator.migrations_paths).migrate
  end

  desc 'Rollback the last migration'
  task :rollback => [:load_migrations, :load_database_settings] do
    ActiveRecord::MigrationContext.new(ActiveRecord::Migrator.migrations_paths).rollback
  end

  task :load_migrations => :load_database_settings do
    ActiveRecord::Base.establish_connection(ApplicationConfig.database_config)
    ActiveRecord::Migrator.migrations_paths = [ApplicationConfig.database_migrations_path]
  end

  desc 'Create and migrate the database'
  task :setup => [:create, :migrate]

  desc 'Reset the database'
  task :reset => [:drop, :create, :migrate]

  task :load_database_settings do
    require 'active_record'
    require_relative 'config/application_config'
  end
end

desc 'Start a Pry console'
task :console do
  exec 'bundle', 'exec', 'pry', '-r', './config/environment', '-r', './config/console'
end

desc 'Run the test suite'
task :test do
  exec 'bundle', 'exec', 'rspec'
end

desc 'Run the application'
task :run do
  exec 'bundle', 'exec', 'ruby', './bin/server.rb'
end
