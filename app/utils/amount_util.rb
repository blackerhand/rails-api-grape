module AmountUtil
  module_function

  def amount_cent(amount)
    (amount * 100).to_i
  end

  def cent_to_yuan(amount)
    return BigDecimal(0) if amount.blank?

    (BigDecimal(amount) / 100.0).round(2)
  end
end
