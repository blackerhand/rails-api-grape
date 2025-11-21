# == Schema Information
#
# Table name: file_objects
#
#  id                              :bigint           not null, primary key
#  content_digest(文件内容摘要)    :string
#  disabled_at                     :datetime
#  ext(文件后缀)                   :string(10)
#  file                            :string
#  fileable_type                   :string(80)
#  filename(文件名称)              :string
#  order_index(排序)               :integer          default(0)
#  original_filename(原始文件名称) :string
#  size(文件大小)                  :decimal(10, 2)
#  type                            :string(80)
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  created_user_id                 :bigint
#  fileable_id                     :bigint
#  updated_user_id                 :bigint
#
# Indexes
#
#  index_file_objects_on_created_user_id                (created_user_id)
#  index_file_objects_on_disabled_at                    (disabled_at)
#  index_file_objects_on_fileable_id_and_fileable_type  (fileable_id,fileable_type)
#
class FileObjectSerializer < ApplicationSerializer
  attributes :id, :file_url, :filename, :filename_with_ext, :ext, :download_path,
             :is_img
end
