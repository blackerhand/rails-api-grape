class UpdateBase < BaseService
  attr_accessor :record, :params, :changes, :is_update, :opts, :transaction

  def initialize(record, params, opts = {})
    @record      = record
    @is_update   = record.persisted?
    @opts        = opts
    @params      = params
    @transaction = opts[:transaction] || true

    @record.assign_attributes(@params)
    @changes = @record.changes
  end

  def execute
    # TODO 由于修改图片 id 不会引发 change 修改,  这里 先注释
    # return self if changes.blank?

    validate_params!

    if transaction
      ActiveRecord::Base.transaction do
        save_record!
        after_save!
      end
    else
      save_record!
      after_save!
    end

    self
  end

  def is_create
    !is_update
  end

  def changes?(key)
    changes.key?(key.to_s)
  end

  def before_valid!
  end

  def save_record!

    record.save!
  end

  def callback
  end

  def after_save!
  end

  def validate_params!
    record.assign_attributes(params)

    before_valid!
  end
end
