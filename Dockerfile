FROM ruby:3.3.1-slim

WORKDIR /app

# Install packages needed by gems
RUN apt-get update && apt-get install -y gcc g++ make pkg-config libc-dev libffi-dev libsqlite3-dev libsodium-dev libopus-dev ffmpeg

# Throw errors if `Gemfile` has been modified since `Gemfile.lock`
RUN bundle config --global frozen 1

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

ENV DISCORDRB_FANCY_LOG=true

CMD ["ruby", "bin/server.rb"]
