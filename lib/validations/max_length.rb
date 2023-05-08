class MaxLength < Grape::Validations::Base
  def validate_param!(attr_name, params)
    return if params[attr_name].to_s.length <= @option

    raise Grape::Exceptions::Validation.new params: [@scope.full_name(attr_name)], message: "最长为 #{@option} 字符"
  end
end
