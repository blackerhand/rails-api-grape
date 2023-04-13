if Settings.REDIS_URL.present?
  Sidekiq.configure_server do |config|
    config.redis = { namespace: 'sidekiq', url: Settings.REDIS_URL, password: Settings.REDIS_PASSWD }
  end

  Sidekiq.configure_client do |config|
    config.redis = { namespace: 'sidekiq', url: Settings.REDIS_URL, password: Settings.REDIS_PASSWD }
  end
end

schedule_file = File.join(Rails.root, "config/scheduler/#{Rails.env}.yml")

if Sidekiq.server? && File.exists?(schedule_file)
  Sidekiq::Cron::Job.load_from_hash! YAML.load_file(schedule_file)
end
