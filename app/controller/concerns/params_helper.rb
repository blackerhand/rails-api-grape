module ParamsHelper
  def declared_params(key = params_scope)
    real_params.send key
  end

  def real_params
    declared(params, include_missing: false)
  end

  def full_params
    declared(params, include_missing: true)
  end

  def params_q
    params.q || Hashie::Mash.new
  end

  def page_per
    per = params[:per] || GRAPE_API::PER_PAGE
    per.to_i > 99 ? 99 : per.to_i
  end

  def params_page
    params[:page] || 1
  end

  def params?(key)
    params.key?(key) || declared_params.try(:key?, key)
  end

  # 解决 full_params Array[JSON] 对象为空时, 参数不为数组的 BUG
  def map_array_json(array_params)
    return [] unless array_params.is_a?(Array)

    array_params.map(&:to_hash)
  end

  def params_blank?(attr)
    return true if attr.blank?
    return attr.select(&:present?).blank? if attr.is_a? Array

    false
  end

  # 使用 ids 进行检索, 若 ids 中有不存在的 id, 返回 []
  def query_by_ids(base_query, ids)
    return [] if ids.blank?

    ids     = [ids] unless ids.is_a?(Array)
    records = base_query.where(id: ids)
    return [] unless ids.length == records.length

    records
  end
end
