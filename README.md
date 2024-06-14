# Red Panda Challenge

## Commands

- `Ping!` - displays 'Pong!'
- `!user` - displays your username and user id
- `!count` - increments a counter for your user

## Installing the program

```bash
git clone git@github.com:red-panda-industries/red-panda-challenge.git
cd red-panda-challenge
```

Then, copy `.env.example` into `.env` and update it with your Discord API credentials.
(Alternatively, run the program with environment variables.)

## Running the program

### With Docker (recommended)

Build the Red Panda Challenge Docker container:
```bash
docker build . -t 'red-panda-industries/rpc:latest'
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

### Without Docker

Install Ruby 3.3.1.

Install these packages:
```
sudo apt-get install -y build-essential libffi-dev libsqlite3-dev
```

Install Ruby dependencies:
```bash
bundle install
```

Set up the database:
```bash
bundle exec rake db:setup
```

Run the program:
```bash
bundle exec ruby app.rb
```

Show the Rake tasks:
```bash
bundle exec rake --tasks
```