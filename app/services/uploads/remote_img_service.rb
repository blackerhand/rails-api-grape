module Uploads
  class RemoteImgGetError < StandardError; end

  class RemoteImgService < BaseService
    attr_accessor :url

    def initialize(url)
      @url = url
    end

    def execute
      return if url.blank?

      rsq_body = RestClient.get(url)

      file_name, url_ext = File.basename(url).split('.')
      url_ext            ||= get_image_format!(rsq_body)
      temp_file          = Tempfile.create([file_name, ".#{url_ext}"])
      temp_file.write rsq_body.force_encoding('UTF-8')
      temp_file.rewind
      temp_file
    rescue => e
      # rescue OpenSSL::SSL::SSLError,
      #   ArgumentError,
      #   Net::OpenTimeout,
      #   RestClient::NotFound,
      #   RestClient::Exceptions::OpenTimeout,
      #   RestClient::GatewayTimeout,
      #   RestClient::BadGateway,
      #   # RestClient::Exception,
      #   RestClient::InternalServerError => e
      error_notify("RemoteImgGetError: #{e.class} #{url}, #{e.message}")
      raise RemoteImgGetError, "#{e.class}: #{e.message}"
    end
  end
end
