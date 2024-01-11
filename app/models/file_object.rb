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
#
# Indexes
#
#  index_file_objects_on_created_user_id                (created_user_id)
#  index_file_objects_on_disabled_at                    (disabled_at)
#  index_file_objects_on_fileable_id_and_fileable_type  (fileable_id,fileable_type)
#
class FileObject < ApplicationRecord
  include Disable

  scope :not_association, -> { where(fileable: nil) }
  scope :not_association_by_owner, ->(owner_id) { where(created_user_id: owner_id, fileable: nil) }

  belongs_to :fileable, polymorphic: true, optional: true
  mount_uploader :file, FileUploader

  before_create :set_file_attrs

  def download_path
    "/v1/files/#{id}"
  end

  def real_file_path
    file.path || "public/#{file_url}"
  end

  def full_url
    Settings.HOST + file_url
  end

  def self.query_by_url(url)
    return unless url.to_s.start_with?(Settings.HOST)

    where(id: url.split('/')[-2]).first
  end

  def filename_with_ext
    file.try(:identifier)
  end

  private

  def set_file_attrs
    return unless file.try(:file)

    o_file             = file.file
    original_name, ext = o_file.filename.split('.')

    self.filename       = original_name
    self.ext            = ext
    self.size           = o_file.size
    self.content_digest = Digest::SHA1.hexdigest(o_file.read)
  end
end
