# == Schema Information
#
# Table name: file_objects
#
#  id                              :bigint           not null, primary key
#  content_digest(文件内容摘要)    :string(255)
#  disabled_at                     :datetime
#  ext(文件后缀)                   :string(10)
#  file                            :string(255)
#  fileable_type                   :string(40)
#  filename(文件名称)              :string(255)
#  order_index(排序)               :integer          default(0)
#  original_filename(原始文件名称) :string(255)
#  size(文件大小)                  :decimal(10, 2)
#  type                            :string(40)
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  created_user_id                 :bigint
#  fileable_id                     :bigint
#  updated_user_id                 :bigint
#  user_id(上传人)                 :integer
#
# Indexes
#
#  index_file_objects_on_disabled_at                    (disabled_at)
#  index_file_objects_on_fileable_id_and_fileable_type  (fileable_id,fileable_type)
#  index_file_objects_on_user_id                        (user_id)
#
module Files
  class ContentImg < ImageObject
  end
end
