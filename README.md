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

Set up the database:
```bash
docker run --rm -it -v './var':'/app/var' --entrypoint '/bin/sh' 'red-panda-industries/rpc:latest' -c 'rake db:setup'
```

Run the Red Panda Challenge Docker container:
```bash
docker run --rm -it -v './var':'/app/var' 'red-panda-industries/rpc:latest'
```

(For development) Show the Rake tasks:
```bash
docker run --rm -it -v './var':'/app/var' --entrypoint '/bin/sh' 'red-panda-industries/rpc:latest' -c 'rake --tasks'
```

## Application structure

- `app/` - Application source code
- `app/bots/` - Discord bots
- `app/helpers/` - Presentation helpers
- `app/models/` - ActiveRecord models
- `app/red_panda_challenge.rb` - Loads the application
- `bin/server.rb` - Starts the server
- `config/` - Configuration files
- `db/` - ActiveRecord database files
- `initializers/` - Code that gets run on startup
- `var/` - Variable content
- `var/db/` - SQLite database
- `.env` - Environment file
- `.env.example` - Example environment file
- `.ruby-version` - Ruby version file
- `Dockerfile` - Docker container configuration
- `Gemfile` - List of Ruby dependencies
- `Gemfile.lock` - Exact Ruby dependencies (auto-generated)
- `Rakefile` - project build file
