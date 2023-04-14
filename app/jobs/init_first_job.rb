class InitFirstJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts 'haha ...'
  end
end
