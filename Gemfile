source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Typeahead
gem 'twitter-typeahead-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# add annotations of schema inside models
gem 'annotate'

# CanCan is used for authorization
gem 'cancan'
gem 'httparty'

# Acts as singleton
gem 'acts_as_singleton'

# Barcodes
gem 'barcodes', git: "git://github.com/nudded/barcodes"

# Authentication
gem 'devise'

# Paper trail is supercool
gem 'paper_trail', '~> 4.0.0.beta'

# Paperclip for barcode attachments
gem "paperclip", "~> 4.3"

# Errbit
gem 'airbrake'

# Token authentication for the partners
gem 'simple_token_authentication'

# Enums
gem 'enumerize'

# Coverall
gem 'coveralls', require: false

group :production, :deployment do
  gem 'puma'
end

group :development do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  # Deployment
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rvm'
end

group :production do
  gem 'mysql2' # Database
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use debugger
# gem 'debugger', group: [:development, :test]
