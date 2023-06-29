module Uploads
  class RemoteImgGetError < StandardError; end

  class RemoteImgService < BaseService
    attr_accessor :url

    def initialize(url)
      @url = url
    end

    def execute
      return if url.blank?

      file_name, url_ext = File.basename(url).split('.')
      url_ext            ||= get_imgage_format!(rsq_body)
      temp_file          = Tempfile.create([file_name, ".#{url_ext}"])
      temp_file.write rsq_body.force_encoding('UTF-8')
      temp_file.rewind
      temp_file
    rescue OpenSSL::SSL::SSLError => _e
      nil
    end
  end
end
