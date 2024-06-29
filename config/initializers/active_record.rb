ActiveRecord::Base.logger = Logger.new($stdout, progname: 'ActiveRecord')
ActiveRecord::Base.establish_connection(Application.database_config)

at_exit do
  ActiveRecord::Base.connection.close
end

unless ActiveRecord::Base.connection.table_exists?('schema_migrations')
  fail "The database file does not exist for the #{Application.environment} environment. Run 'RAILS_ENV=#{Application.environment} rake db:setup' to set up the database"
end

if ActiveRecord::Base.connection.migration_context.needs_migration?
  fail "You have database migrations that need to be run in the #{Application.environment} environment. Run 'RAILS_ENV=#{Application.environment} rake db:migrate' to update the database schema."
end
