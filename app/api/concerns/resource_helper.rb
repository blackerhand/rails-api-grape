module ResourceHelper
  def controller_path
    source.to_s.match(/\/v\d+\/(\w+\/)?\w+_grape/).to_s
  end

  def controller_class
    controller_path[1..-1].classify
  end

  def controller_name
    source.to_s.match(/(\w+)_grape/)[1]
  end

  def params_scope
    controller_name.singularize
  end

  # def action_name
  #   actions = routes.first.origin.gsub(/(\/v\d+)|(:)/, '').split('/').delete_if { |str| str.blank? || str == controller_name }
  #   actions.unshift(request_method).join('_')
  # end
  def action_name
    path = routes.first.origin.delete(controller_path)
    "#{request_method}_#{path.presence || 'index'}"
  end

  def action_full_name
    request.request_method.downcase + routes.first.origin.gsub(/((\/v\d+)\/|(\/:))|\//, '_')
  end

  def record_class
    controller_name.singularize.classify.safe_constantize
  end

  def request_method
    request.request_method.downcase
  end
end
