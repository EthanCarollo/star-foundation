
FROM ruby:3.1.4

WORKDIR /app

COPY . /app

RUN bundle install

CMD ["ruby", "main.rb"]