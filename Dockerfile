#FROM circleci/ruby:2.6.9
FROM ruby:3.2.2

RUN ["gem", "install", "bundler", "-v", "2.3.24"]
RUN ["gem", "install", "foreman"]
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000

#CMD ["foreman", "start"]
