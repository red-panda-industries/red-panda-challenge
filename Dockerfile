FROM ruby:3.3.1-alpine

# install libffi-dev for ffi gem
RUN apk add --no-cache build-base libffi-dev

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["ruby", "app.rb"]
