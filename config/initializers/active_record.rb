ActiveRecord::Base.logger = Logger.new($stdout, progname: 'ActiveRecord')
ActiveRecord::Base.establish_connection(Application.database_config)

at_exit do
  ActiveRecord::Base.connection.close
end

unless ActiveRecord::Base.connection.table_exists?('schema_migrations')
  abort 'The database file does not exist. Run "rake db:setup" to set up the database'
end

if ActiveRecord::Base.connection.migration_context.needs_migration?
  abort 'You have database migrations that need to be run. Run "rake db:migrate" to update the database schema.'
end