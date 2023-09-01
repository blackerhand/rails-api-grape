# 手机号验证util
class MobileUtil
  # 验证手机号格式：暂时只验证了前2位及总位数
  # TODO：更精细的正则
  def self.number_valid?(mobile_number)
    /\A1[3456789]\d{9}\z/.match?(mobile_number)
  end

  # 手机号中间脱敏（此处认为传过来的都是11位字符串）
  def self.mask_number(mobile_number)
    return '' if mobile_number.blank?

    "#{mobile_number.first(3)}****#{mobile_number.last(4)}"
  end
end
