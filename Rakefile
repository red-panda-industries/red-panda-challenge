namespace :db do
  desc 'Create the database'
  task :create => :load_database_settings do
    if File.exist?(Application.database_filename)
      puts "Database '#{Application.database_filename}' already exists"
      next
    end

    puts "Creating database '#{Application.database_filename}'"
    database_dirname = File.dirname(Application.database_filename)
    FileUtils.mkdir_p(database_dirname) unless Dir.exist?(database_dirname)
    ActiveRecord::Base.establish_connection(Application.database_config)
    ActiveRecord::Base.connection # This will create the SQLite file
  end

  desc 'Drop the database'
  task :drop => :load_database_settings do
    if File.exist?(Application.database_filename)
      puts "Dropping database '#{Application.database_filename}'"
      File.delete(Application.database_filename)
    else
      puts "Database '#{Application.database_filename}' does not exist"
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
    ActiveRecord::Base.establish_connection(Application.database_config)
    ActiveRecord::Migrator.migrations_paths = [Application.database_migrations_path]
  end

  desc 'Create and migrate the database'
  task :setup => [:create, :migrate]

  desc 'Reset the database'
  task :reset => [:drop, :create, :migrate]

  desc 'Dump the database schema'
  task 'schema:dump' => :load_database_settings do
    schema_file = File.open(Application.db_schema_filename, 'w')
    puts "Dumping database schema to '#{schema_file.path}'"

    ActiveRecord::Base.establish_connection(Application.database_config)
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, schema_file)
  end

  task :load_database_settings do
    require 'active_record'
    require_relative 'config/application'
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
