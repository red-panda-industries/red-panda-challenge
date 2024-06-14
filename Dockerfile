FROM ruby:3.3.1-slim

# Install packages needed by gems
RUN apt-get update && apt-get install -y build-essential libffi-dev libsqlite3-dev

# Throw errors if `Gemfile` has been modified since `Gemfile.lock`
RUN bundle config --global frozen 1

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Suppress warning message about missing `libsodium` used for voice support
ENV DISCORDRB_NONACL=true

CMD ["ruby", "app.rb"]
