FROM ruby:3.3.1-alpine

# Install `libffi-dev` for `ffi` gem needed by `discordrb`
RUN apk add --no-cache build-base libffi-dev

# Throw errors if `Gemfile` has been modified since `Gemfile.lock`
RUN bundle config --global frozen 1

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["ruby", "app.rb"]
