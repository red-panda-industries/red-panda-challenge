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
docker run --rm -it -v ./db:/app/db -v ./log:/app/log red-panda-challenge
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
