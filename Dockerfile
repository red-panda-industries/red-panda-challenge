FROM ruby:3.3.1-alpine

# Install packages needed by `discordrb`
RUN apk add --no-cache build-base libffi-dev

# Throw errors if `Gemfile` has been modified since `Gemfile.lock`
RUN bundle config --global frozen 1

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Suppress warning message about missing `libsodium` used for voice support
ENV DISCORDRB_NONACL=true

CMD ["ruby", "app.rb"]
