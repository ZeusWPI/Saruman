FROM ruby:3.3.1

ENV RAILS_ENV=production
WORKDIR /app

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install -y yarn libnss3 libxss1 libasound2 libatk-bridge2.0-0 libgtk-3-0 libgbm-dev libmagickcore-dev imagemagick

COPY ./Gemfile ./Gemfile.lock /app/

RUN gem install bundler
RUN bundle install

COPY . /app

RUN bundle exec rails assets:precompile

CMD bundle exec rails s -b 0.0.0.0
