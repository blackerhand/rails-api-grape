module FieldHelper
  def tran_model_field(model_field)
    model_string, field_key_string = model_field.split('.')
    model_string                   = model_string.to_s.classify
    model_class                    = model_string.safe_constantize
    field_key                      = field_key_string.to_s.underscore
    return unless safe_field(model_class, field_key)

    [model_class, field_key]
  end

  def safe_field(model_class, field_key)
    return true if model_class&.column_names&.include?(field_key)
    return true if field_key.to_s == 'stat_fields'

    false
  end

  def not_association_file(file_class, file_id)
    file_class.not_association_by_owner(PaperTrail.request.whodunnit).find_by(id: file_id)
  end

  def update_file_object(record, file_class, file_id)
    file_field = file_class.to_s.underscore.gsub('/', '_')

    old_file = record.send(file_field)
    return if old_file&.id == file_id

    new_file = not_association_file(file_class, file_id)
    valid_error!('file_not_found') if new_file.blank?
    record.send("#{file_field}=", new_file)

    new_file
  end

  def neared_ary(ary, current, size)
    return [] unless ary.include?(current)
    return [] if size <= 0

    current_index = ary.index(current)

    prev_index = current_index - size >= 0 ? current_index - size : 0
    next_index = current_index + size < ary.size ? current_index + size : ary.size - 1

    ary[prev_index..next_index]
  end
end
