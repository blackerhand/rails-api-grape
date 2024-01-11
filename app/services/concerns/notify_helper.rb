module NotifyHelper
  def error_notify(message)
    Rails.logger.error("Error Message: #{message}")
    Bugsnag.notify(message)
  end
end
