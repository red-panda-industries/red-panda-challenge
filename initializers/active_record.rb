require 'active_record'
require 'logger'
require 'sqlite3'

require_relative 'application_config'

ActiveRecord::Base.logger = Logger.new($stdout)
ActiveRecord::Base.establish_connection(ApplicationConfig.database_config)

at_exit do
  ActiveRecord::Base.connection.close
end

unless ActiveRecord::Base.connection.table_exists?('schema_migrations')
  abort 'The database file does not exist. Run "rake db:setup" to set up the database'
end

if ActiveRecord::Base.connection.migration_context.needs_migration?
  abort 'You have database migrations that need to be run. Run "rake db:migrate" to update the database schema.'
end