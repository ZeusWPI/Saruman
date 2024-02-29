# frozen_string_literal: true
source 'https://rubygems.org'

ruby "3.3.0"

gem 'dotenv-rails'

gem 'bundler', '>= 2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.1'

# Bootsnap makes booting snappy
gem 'bootsnap'

# Frontend stuff
gem "cssbundling-rails", "~> 1.1"
gem "jsbundling-rails"

# Tubro-rails makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# add annotations of schema inside models
gem 'annotate'

# CanCan is used for authorization
gem 'cancancan'
gem 'httparty'

# Acts as singleton
gem 'acts_as_singleton'

# Barcodes
#gem 'barcodes', git: 'git://github.com/nudded/barcodes'
gem 'barcodes'
gem 'chunky_png'
gem 'barby'
gem 'matrix'

# Authentication
gem 'devise'

# Paper trail is supercool
gem 'paper_trail'

# Sentry (actually glitchtip)
gem 'sentry-rails'

# Token authentication for the partners
gem 'simple_token_authentication'

# PDF goodies
gem 'grover'

# Database
gem 'pg'

# Inline svgs
gem 'inline_svg'

# Excel exports
gem 'caxlsx'
gem 'caxlsx_rails'

# Rainbow for console colours
gem 'rainbow', require: false

group :production, :deployment do
  gem 'puma'
end

group :development do
  # Deployment
  gem "capistrano", "~> 3.11", require: false
  gem 'capistrano-docker', github: 'TomNaessens/capistrano-docker'
  gem 'ed25519', require: false
  gem 'bcrypt_pbkdf', require: false

  # Mails
  gem 'letter_opener'
  gem 'web-console'

  # Rails 5 goodies
  gem 'listen'
end

group :development, :test do
  gem 'rails_style', github: 'ZeusWPI/rails_style'
  gem 'rubocop-minitest'
end

group :test do
  gem 'rails-controller-testing' # assigns helper
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
