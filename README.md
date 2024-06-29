# Red Panda Challenge

## Commands

- `!user` - displays your username and user id
- `!count` - increments a counter for your user
- `!michelle` - registers a daily entry for the Michelle Obama challenge

## Installing the program

```bash
git clone git@github.com:red-panda-industries/red-panda-challenge.git
cd red-panda-challenge
```

Then, copy `.env.example` into `.env` and update it with your Discord API credentials.
(Alternatively, run the program with environment variables.)

## Running the program

Docker is required.

Build the Red Panda Challenge Docker container:
```bash
docker buildx build . -t 'red-panda-industries/rpc:latest'
```

Start a shell inside the container:
```bash
docker run --rm -it -v './var':'/app/var' --entrypoint '/bin/bash' 'red-panda-industries/rpc:latest'
```

Inside the container, set up the database for each environment:
```bash
RAILS_ENV=development rake db:setup
RAILS_ENV=test        rake db:setup
RAILS_ENV=production  rake db:setup
```

Run the tests:
```bash
rspec
```

On your host machine, run the Red Panda Challenge Docker container:
```bash
docker run --rm -it -v './var':'/app/var' 'red-panda-industries/rpc:latest'
```


## Application structure

- `app/` - Application source code
- `app/bots/` - Discord bots
- `app/helpers/` - Presentation helpers
- `app/models/` - ActiveRecord models
- `bin/server.rb` - Starts the server
- `config/` - Configuration files
- `config/application.rb` - Loads the application
- `config/initializers/` - Code that gets run on startup
- `db/migrate` - ActiveRecord database migrations
- `spec/` - Test code
- `var/` - Variable content
- `var/db/` - SQLite database
- `var/log/` - Log files
- `.env` - Environment file
- `.env.example` - Example environment file
- `.ruby-version` - Ruby version file
- `Dockerfile` - Docker container configuration
- `Gemfile` - List of Ruby dependencies
- `Gemfile.lock` - Exact Ruby dependencies (auto-generated)
- `Rakefile` - project build file
