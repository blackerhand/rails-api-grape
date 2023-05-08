class InitFirstJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Rails.logger.debug 'haha ...'
  end
end
