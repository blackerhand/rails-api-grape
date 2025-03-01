require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsApiGrapeV2
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("app", 'api')
    config.autoload_paths << "#{root}/app/api"

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.i18n.default_locale = :'zh-CN'
    config.time_zone           = 'Beijing'

    config.active_job.queue_adapter = :sidekiq

    config.cache_store = :redis_cache_store, {
      url:        Settings.REDIS_URL || 'redis://127.0.0.1:6379/1',
      password:   Settings.REDIS_PASSWD,
      expires_in: 90.minutes
    }

    config.middleware.use BatchLoader::Middleware
    config.middleware.use HttpStore::Middleware::RequestLog
    config.action_cable.allowed_request_origins = [%r{https?://\S+}, "chrome-extension://cbcbkhdmedgianpaifchdaddpnmgnknn"]
  end
end
