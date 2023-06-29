module FieldHelper
  def tran_model_field(model_field)
    model_string, field_key_string = model_field.split('.')
    model_string                   = model_string.to_s.classify
    model_class                    = model_string.safe_constantize
    field_key                      = field_key_string.to_s.underscore

    return unless model_class&.column_names&.include?(field_key)

    [model_class, field_key]
  end
end
