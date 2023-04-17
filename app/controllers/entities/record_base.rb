module Entities
  # only for data_build_helper#entities_record
  class RecordBase < Base
    expose :id
    expose(:class) { |record| record.try(:type) || record.class.to_s }
    with_options(format_with: :time_detail_format) { expose :created_at, :updated_at, if: proc { |record| record.try(:created_at) } }

    with_options(format_with: :time_format) do
      expose :created_at, as: :created_date, documentation: { desc: '创建时间' }
      expose :updated_at, as: :updated_date, documentation: { desc: '更新时间' }
    end

    expose(:attributes) { |instance, options| options[:glass].represent instance, options }
  end
end
