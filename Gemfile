source "https://rubygems.org"
# source 'https://gems.ruby-china.com'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4"
gem 'rails-i18n', '~> 7.0.0'
gem 'sprockets-rails'

# Use mysql as the database for Active Record
# gem "mysql2", "~> 0.5"
gem 'pg'

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.2"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 5.3'
gem 'redis-rails'
# gem 'redis-namespace'

# 敏感词过滤
gem 'sensitive'

gem 'sidekiq', '~> 7.3'
gem 'sidekiq-cron', '~> 1.12'

gem 'config'

# valid
gem 'jwt', '~> 2.1'
gem 'bcrypt', '~> 3.1.18'
# gem "pundit", '~> 2.3'
gem 'rolify', '~> 6.0'

# https://github.com/ruby/net-imap/issues/16
gem 'net-http', '~> 0.3'
# gem 'net-smtp'
# gem 'net-imap'
gem 'uri', '~> 0.10'

# file
gem 'carrierwave', '~> 3.0.7'
gem 'rmagick'
gem 'data_uri'
gem 'paper_trail', '~> 14.0'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

gem 'grape', '~> 1.7'
# gem 'grape-entity', '~> 1.0'
gem 'grape-rails-cache'
gem 'hashie'
gem 'hashie-forbidden_attributes'

gem 'grape-swagger'
# gem 'grape-swagger-entity'
gem 'grape-swagger-rails'

gem 'kaminari', '~> 1.2'
gem 'ransack', '~> 4.1'
gem 'ransack-enum'
gem 'ancestry', '~> 4.3'

gem 'foreman'

# html parse
gem 'loofah-activerecord'

gem 'aasm'

gem 'http_store', '0.7.2', require: true #, git: 'https://github.com/blackerhand/http-store.git'

gem 'action-store'

# gem 'request-log-analyzer'
# gem 'jbuilder'
# gem 'jsonapi-serializer'
gem 'active_model_serializers', '~> 0.10.14'
gem 'batch-loader', '~> 2.0'
gem "ams_lazy_relationships"

gem "bugsnag"
gem "uniform_notifier"

gem 'binance-connector-ruby'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'pry-byebug'
  gem 'pry-rails'

  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-performance'

  # TDD
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'faker'
  gem 'ffaker', '~> 2.9'
  gem 'webmock'

  gem 'awesome_print'

  gem 'i18n_generators'
  # gem 'rails-i18n-generator'
  gem 'ruby-lsp'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'capistrano', '~> 3.17'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'capistrano3-puma', github: "seuros/capistrano-puma"
  gem 'capistrano-sidekiq'
  gem 'capistrano3-nginx', '~> 2.0'

  gem 'ed25519', '>= 1.2', '< 2.0'
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'

  # model comment
  gem 'annotate'
end
