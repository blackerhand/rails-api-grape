Bugsnag.configure do |config|
  config.api_key = Settings.BUGSNAG_API_KEY
end

# bugsnag
UniformNotifier.bugsnag = true
# bugsnag with options
UniformNotifier.bugsnag = { :api_key => Settings.BUGSNAG_API_KEY }
