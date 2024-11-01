class AutoJob < ApplicationJob
  def init_job
    records.each { |record| self.class.perform_later(record.id) }
  end

  def records
    raise 'Please implement this method in subclass'
  end

  def record
    @record ||= records.find_by(id: record_id)
  end

  def record_id
    @arguments.first
  end

  def is_init_job?
    @arguments.blank?
  end

  def execute_method
    nil
  end

  def execute_service
    nil
  end

  def execute_opts
    @arguments.last || {}
  end

  def perform(*args)
    return init_job if is_init_job?
    return if record.blank?

    execute_service.execute(record, execute_opts) if execute_service
    execute_method
  end
end
