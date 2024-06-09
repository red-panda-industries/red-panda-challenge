# Red Panda Challenge

## Installation

```bash
git clone git@github.com:red-panda-industries/red-panda-challenge.git
cd red-panda-challenge
```

Then, update `.env` with your Discord API credentials:
```bash
cp .env.example .env
editor .env
```

### With Docker (recommended)

Build the Red Panda Challenge Docker container:
```bash
docker build . -t red-panda-challenge
```

Run the Red Panda Challenge Docker container:
```bash
RED_PANDA_CHALLENGE_DB_DIR="$(pwd)/db"
RED_PANDA_CHALLENGE_LOG_DIR="$(pwd)/log"
docker run --rm -it -v "$RED_PANDA_CHALLENGE_DB_DIR:/app/db" -v "$RED_PANDA_CHALLENGE_LOG_DIR:/app/log" red-panda-challenge
```

### Without Docker

With Ruby 3.3.1 installed:

Install Ruby dependencies:
```bash
bundle install
```

Run the program:
```
bundle exec ruby app.rb
```
