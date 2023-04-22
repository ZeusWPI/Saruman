source 'https://rubygems.org'

ruby "2.7.8"

# Dotenv, first
gem 'dotenv-rails'

# Bundler
gem 'bundler', '>= 2.4.10'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.8.1'

# Use SCSS for stylesheets
gem 'sass-rails'

gem 'bootsnap'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'mini_racer'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Typeahead
gem 'twitter-typeahead-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

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

# Authentication
gem 'devise'

# Paper trail is supercool
gem 'paper_trail'

# Paperclip for barcode attachments
gem 'paperclip'

# Sentry (actually glitchtip)
gem 'sentry-rails'

# Token authentication for the partners
gem 'simple_token_authentication'

# Send bills
gem 'wicked_pdf'

group :production, :deployment do
  gem 'puma'
end

group :development do
  # Deployment
  gem "capistrano", "~> 3.11", require: false
  gem "capistrano-rails", "~> 1.4", require: false
  gem 'capistrano-rbenv'
  gem 'capistrano-rvm'

  # Mails
  gem 'letter_opener'
  gem 'web-console', '~> 3.0'

  # Rails 5 goodies
  gem 'listen'
end

group :production do
  gem 'mysql2' # Database
end

group :test do
  gem 'rails-controller-testing' # assigns helper
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use debugger
# gem 'debugger', group: [:development, :test]
gem 'axlsx'
gem 'axlsx_rails'
