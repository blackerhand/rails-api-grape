class IdCard < Grape::Validations::Validators::Base
  def validate_param!(attr_name, params)
    return if params[attr_name].blank?
    return if IdcardUtil.valid?(params[attr_name])

    raise Grape::Exceptions::Validation.new params: [@scope.full_name(attr_name)], message: "身份证号格式不正确"
  end
end
