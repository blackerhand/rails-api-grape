source "https://rubygems.org"
# source 'https://gems.ruby-china.com'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.6"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4"
gem 'rails-i18n', '~> 7.0.0'
gem 'sprockets-rails'

# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.2"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem 'redis'
gem 'redis-rails'
gem 'redis-namespace'

gem 'sidekiq', '~> 6.5'
gem 'sidekiq-cron', '~> 1.10'

gem 'config'

# valid
gem 'jwt', '~> 2.1'
gem 'bcrypt', '~> 3.1.18'
gem "pundit", '~> 2.3'
gem 'rolify', '~> 6.0'

# file
gem 'carrierwave', '>= 3.0.0.beta', '< 4.0'
gem "net-http", '~> 0.3'

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
gem 'grape-entity', '~> 1.0'
gem 'hashie'
gem 'hashie-forbidden_attributes'

gem 'grape-swagger'
gem 'grape-swagger-entity'
gem 'grape-swagger-rails'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'pry-byebug'
  gem 'pry-rails'
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

  gem 'ed25519', '>= 1.2', '< 2.0'
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
end

