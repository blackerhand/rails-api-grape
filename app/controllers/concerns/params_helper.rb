module ParamsHelper
  def declared_params
    declared(params, include_missing: false)
  end

  def full_params
    declared(params, include_missing: true)
  end

  # 解决 full_params Array[JSON] 对象为空时, 参数不为数组的 BUG
  def map_array_json(array_params)
    return [] unless array_params.is_a?(Array)

    array_params.map(&:to_hash)
  end

  def params_blank?(attr)
    return true if attr.blank?
    return attr.select { |at| at.present? }.blank? if attr.is_a? Array

    false
  end
end
