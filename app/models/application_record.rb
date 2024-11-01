class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  include Disable
  include PreEnum
  include HasFileable

  def self.where_array(filed, *values)
    if values.length == 1
      where("'#{values.first}' = ANY (#{filed})")
    else
      where("#{filed} @> ARRAY[?]::varchar[]", values)
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    column_names + _ransackers.keys
  end

  def type
    self.class
  end

  def self.ransackable_associations(auth_object = nil)
    reflect_on_all_associations.map { |a| a.name.to_s } + _ransackers.keys
  end

  def set_origin_data(hash)
    return if hash.blank?

    self.origin_data = (origin_data || {}).merge(hash)
  end

  # 解决事务中, 修改 file_object 的 file 属性文件存储在 tmp 中的问题
  def modify_has_one_file!(field, file)
    return if file.nil?

    file_object      = send "build_#{field}"
    file_object.file = file
    file_object.save!
  end

  def uniq_id
    "#{self.class}_#{id}"
  end
end
