module Entities
  # all entities base
  class Base < Grape::Entity
    include ExposeWithDoc

    expose :id

    format_with(:date_format) { |dt| dt&.strftime('%F') }
    format_with(:time_format) { |dt| dt&.strftime('%F %T') }
    format_with(:thousand_yuan) { |num| ActiveSupport::NumberHelper.number_to_currency(num * 1000, unit: '', precision: 2, format: '%u%n') if num }

    format_with(:decimal_round2) { |dt| format('%.2f', dt.round(2)).gsub(/\.00$/, '') if dt.is_a?(BigDecimal) }
    format_with(:decimal_format) { |dt| dt.to_f.to_s.gsub(/\.0$/, '') if dt.is_a?(BigDecimal) }
  end
end
