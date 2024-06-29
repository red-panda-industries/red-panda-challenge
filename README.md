# Red Panda Challenge

[![RSpec workflow](https://github.com/red-panda-industries/red-panda-challenge/actions/workflows/rspec.yml/badge.svg)](https://github.com/red-panda-industries/red-panda-challenge/actions/workflows/rspec.yml) [![Docker image workflow](https://github.com/red-panda-industries/red-panda-challenge/actions/workflows/docker-image.yml/badge.svg)](https://github.com/red-panda-industries/red-panda-challenge/actions/workflows/docker-image.yml)

The Red Panda Challenge is a Discord bot.

It is written in Ruby and runs inside a Docker container.

## Commands

- `!user` - displays your username and user id
- `!count` - increments a counter for your user
- `!michelle` - registers a daily entry for the "Michelle Obama Challenge"

## Installing the program

### Getting the code

```bash
git clone git@github.com:red-panda-industries/red-panda-challenge.git
cd red-panda-challenge
```

### Getting a Discord bot token

Go to the [Discord Developer Portal](https://discord.com/developers/applications)

### Setting the environment variables

- `DISCORD_BOT_TOKEN` - Discord bot token
- `RAILS_ENV` - Rails environment (development, test, production)

Optionally, create an `.env` file to store these variables.

See `.env.example` for an example.

### Running the program

Build the Red Panda Challenge container:
```bash
docker buildx build . -t red-panda-industries/rpc:latest
```

Set up the database for the environments you're going to use:
```bash
docker run --rm -it -v .:/app -e RAILS_ENV=development  red-panda-industries/rpc:latest rake db:setup
docker run --rm -it -v .:/app -e RAILS_ENV=test         red-panda-industries/rpc:latest rake db:setup
docker run --rm -it -v .:/app -e RAILS_ENV=production   red-panda-industries/rpc:latest rake db:setup
```

Run the tests:
```bash
docker run --rm -it -v .:/app red-panda-industries/rpc:latest rspec
```

Run the server:
```bash
docker run --rm -it -v .:/app red-panda-industries/rpc:latest
```

Then, to add the bot to your server, follow the invite link printed to the console.

### Development

Show the available tasks:
```bash
docker run --rm -it -v .:/app red-panda-industries/rpc:latest rake --tasks
```

## Application structure

- `.github/workflows/` - GitHub Actions configuration
- `app/` - Application source code
  - `app/bots/` - Discord bots
  - `app/helpers/` - Presentation helpers
  - `app/models/` - ActiveRecord models
  - `app/sounds/` - Sound files
- `bin/server.rb` - Starts the server
- `config/` - Configuration files
  - `config/initializers/` - Code that gets run on startup
  - `config/application.rb` - Application configuration
  - `config/console.rb` - Console configuration
  - `config/database.yml` - Database configuration
  - `config/environment.rb` - Entry point for the application
- `db/` - Database code
  - `db/migrate` - ActiveRecord database migrations
  - `db/schema.rb` - Database schema (auto-generated)
- `spec/` - Test code
  - `spec/factories.rb` - FactoryBot factories
  - `spec/spec_helper.rb` - Test configuration
- `var/` - Variable content to be persisted
  - `var/db/` - SQLite database
  - `var/log/` - Log files
- `.env` - Environment file
- `.env.example` - Example environment file
- `.ruby-version` - Ruby version file
- `Dockerfile` - Docker container configuration
- `Gemfile` - List of Ruby dependencies
- `Gemfile.lock` - Exact Ruby dependencies (auto-generated)
- `Rakefile` - project build file
