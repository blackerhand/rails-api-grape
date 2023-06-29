module Uploads
  class Base64Service < BaseService
    def initialize(base64_str)
      @base64_str = base64_str
    end

    def execute
      file_name = Digest::MD5.hexdigest(@base64_str)

      result         = format_data_uri(@base64_str)
      url_ext, bytes = result if result
      bytes          ||= Base64.decode64(@base64_str)
      url_ext        ||= get_imgage_format!(bytes)

      temp_file = Tempfile.create([file_name, ".#{url_ext}"])
      temp_file.write bytes.force_encoding('UTF-8')
      temp_file.rewind
      temp_file
    end
  end
end
