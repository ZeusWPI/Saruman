FROM ruby:2.6.3

ENV RAILS_ENV=production
WORKDIR /app

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install -y yarn

COPY ./Gemfile ./Gemfile.lock /app/

RUN gem install bundler
RUN bundle install

COPY . /app

RUN bundle exec rails assets:precompile

CMD bundle exec rails s -b 0.0.0.0
