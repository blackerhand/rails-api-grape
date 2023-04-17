class FileObject < ApplicationRecord
  include Disable

  belongs_to :fileable, polymorphic: true, optional: true
  belongs_to :user, optional: true
  mount_uploader :file, FileUploader

  before_create :set_file_attrs

  def download_path
    "/v1/files/#{id}"
  end

  def self.find_by_url(url)
    return unless url.to_s.start_with?(Settings.HOST)

    where(id: url.split(/\//)[-2]).first
  end

  def filename_with_ext
    file.try(:identifier)
  end

  private

  def set_file_attrs
    if file.try(:file)
      o_file             = file.file
      original_name, ext = o_file.filename.split(/\./)

      self.filename       = original_name
      self.ext            = ext
      self.size           = o_file.size
      self.content_digest = Digest::SHA1.hexdigest(o_file.read)
    end
  end
end
