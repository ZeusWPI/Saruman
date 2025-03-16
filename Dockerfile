FROM ruby:3.4.2

ENV RAILS_ENV=production
WORKDIR /app

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install -y \
    yarn \
    libnss3 \
    libxss1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libgbm-dev \
    build-essential

COPY ./Gemfile ./Gemfile.lock /app/

RUN gem install bundler
RUN bundle install

COPY . /app

ENV SECRET_KEY_BASE=notsecretonlyforassetprecompilation
RUN bundle exec rails assets:precompile
RUN unset SECRET_KEY_BASE

CMD bundle exec rails s -b 0.0.0.0
