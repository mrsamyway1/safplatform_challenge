FROM ruby:4.0.9-slim

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . ./

ENTRYPOINT ["ruby", "app.rb"]
