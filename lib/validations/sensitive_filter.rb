class SensitiveFilter < Grape::Validations::Validators::Base
  def validate_param!(attr_name, params)
    return unless @option

    input_str = params[attr_name].to_s
    return if input_str.blank?

    sen_keywords = Sensitive.filter(input_str)
    return if sen_keywords.blank?

    raise Grape::Exceptions::Validation.new params: [@scope.full_name(attr_name)], message: "含有敏感词 #{sen_keywords}, 请删除重试"
  end
end
