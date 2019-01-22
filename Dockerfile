FROM ruby:2.6-alpine

RUN gem install bundler:2.0.1

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN apk add --no-cache g++ musl-dev make

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["ruby", "main.rb"]
