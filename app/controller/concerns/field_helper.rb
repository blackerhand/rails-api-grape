module FieldHelper
  def tran_model_field(model_field)
    model_string, field_key_string = model_field.split('.')
    model_string                   = model_string.to_s.classify
    model_class                    = model_string.safe_constantize
    field_key                      = field_key_string.to_s.underscore

    return unless model_class&.column_names&.include?(field_key)

    [model_class, field_key]
  end

  def not_association_file(file_class, file_id)
    file_class.not_association_by_owner(current_user_id).find_by(id: file_id)
  end

  def update_file_object(record, file_class, file_id)
    file_field = file_class.to_s.underscore.gsub('/', '_')

    old_file = record.send(file_field)
    return if old_file&.id == file_id

    new_file = not_association_file(file_class, file_id)
    record.send("#{file_field}=", new_file)
  end
end
