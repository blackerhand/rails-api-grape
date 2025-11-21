module I18n
  module_function

  def t_activerecord(model, attributes = nil)
    model = model.to_s.underscore
    return 'ID' if attributes.to_s.underscore == 'id'
    return '创建时间' if attributes.to_s == 'created_at'
    return '创建日期' if attributes.to_s == 'created_date'
    return '更新时间' if attributes.to_s == 'updated_at'
    return '更新日期' if attributes.to_s == 'updated_date'
    return '页码' if attributes.to_s == 'page'
    return '分页数量' if attributes.to_s == 'per'
    return '禁用时间' if attributes.to_s == 'disabled_at'
    return '排序' if attributes.to_s == 'order_number'
    return '类型' if attributes.to_s == 'class'
    return '点击次数' if attributes.to_s == 'click_number'
    return '操作人' if attributes.to_s == 'owner'

    return if model.blank?

    if attributes.present?
      t("activerecord.attributes.#{model}.#{attributes}")
    else
      t("activerecord.models.#{model}")
    end
  end

  def t_explanation(explanation, opts = {})
    return if explanation.blank?

    t("errors.messages.#{explanation.underscore.gsub(' ', '_')}", opts)
  end

  def safe_t(key)
    text = t(key)
    return if text.to_s.downcase.include?('translation missing')

    text
  end

  def t_message(message)
    safe_t("messages.#{message.underscore}")
  end
end
