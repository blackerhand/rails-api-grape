class ApplicationSerializer < ActiveModel::Serializer
  include AmsLazyRelationships::Core

  attributes :id, :class, :created_user_id

  attributes :serializer_class do
    self.class
  end

  attribute :class do
    object.class
  end

  def self.render_record(field, opts = {})
    attribute field do
      obj              = object.send(field)
      serializer_class = opts[:serializer]

      if obj.blank?
        obj
      elsif obj.is_a?(Array)
        serializer_class ||= "#{obj.first.class}Serializer".constantize
        obj.map { |so| serializer_class.new(so).as_json }
      else
        serializer_class ||= "#{obj.class}Serializer".constantize
        serializer_class.new(obj).as_json
      end
    end
  end

  def record_by_serializer(record, serializer, opts = {})
    return if record.nil?

    opts.merge!(instance_options)
    serializer.new(record, opts).as_json
  end

  def self.date_attribute(attribute, options = {})
    attribute attribute, options do
      object.send(attribute).to_date
    end
  end

  class << self
    def serializer_for(model, options)
      options.delete(:namespace)
      super(model, options)
    end
  end
end
