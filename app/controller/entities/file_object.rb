module Entities
  class FileObject < Base
    expose_with_doc :id, :file_url, :filename, :filename_with_ext, :ext, :download_path
  end
end
