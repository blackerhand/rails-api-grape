module I18n
  module_function

  def t_activerecord(model, attributes = nil, opts = {})
    return if model.blank?

    if attributes.present?
      return 'ID' if attributes.to_s.underscore == 'id'
      return '创建时间' if attributes.to_s == 'created_at'
      return '创建日期' if attributes.to_s == 'created_date'
      return '更新时间' if attributes.to_s == 'updated_at'
      return '更新日期' if attributes.to_s == 'updated_date'
      return 'Canvas ID' if attributes.to_s == 'canvas_id'

      t("activerecord.attributes.#{model}.#{attributes}", opts)
    else
      t("activerecord.models.#{model}", opts)
    end
  end

  def t_explanation(explanation, opts = {})
    return if explanation.blank?

    t("errors.messages.#{explanation.underscore.gsub(' ', '_')}", opts)
  end
end
