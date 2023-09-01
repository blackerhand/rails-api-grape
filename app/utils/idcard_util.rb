# 身份证验证的一些小工具
class IdcardUtil
  ID_REGEXP = Regexp.new(/\A\d{6}(19|20)\d{2}(0[1-9]|1[0-2])(0[1-9]|[1-2]\d|3[0-1])\d{3}(\d|X|x)\z/)
  # 身份证号验证
  WIGHTS = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
  TRANS = %w{1 0 X 9 8 7 6 5 4 3 2}

  class << self
    def valid?(id_no)
      return false if ID_REGEXP.match(id_no).blank?
      id_no.length == 18 && last_no_valid?(id_no)
    end

    # 验证18位身份证最后一个数字符合ISO7064:1983.MOD11-2校验码
    def last_no_valid?(id_no)
      last = TRANS[id_no[0..-2].split('').each_with_index.inject(0){|sum, (val, idx)| sum += val.to_i*WIGHTS[idx]}.modulo(11)]
      id_no[-1].upcase == last.upcase
    end

    # 判断性别
    def sex_info(id_no)
      return '' unless valid?(id_no)
      num = id_no[16].to_i
      num % 2 == 0 ? 'female' : 'male'
    end

    # 身份证号中间脱敏（此处认为传过来的都是18位字符串）
    def mask_number(idcard_number)
      return '' if idcard_number.blank?

      "#{idcard_number.first(6)}********#{idcard_number.last(4)}"
    rescue
      ''
    end
  end
end
