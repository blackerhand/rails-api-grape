module Uploads
  class RemoteImgService < BaseService
    attr_accessor :url

    def initialize(url)
      @url = replace_canvas_http_url(url)
    end

    def execute
      return if url.blank?

      rsq_body = RestClient.get(url) { |response, request, result, &block|
        response.headers[:location] = replace_canvas_http_url(response.headers[:location]) if [301, 302, 307].include? response.code
        response.return!(&block)
      }

      file_name, url_ext = File.basename(url).split(/\./)
      url_ext            ||= get_image_format!(rsq_body)
      temp_file          = Tempfile.create([file_name, ".#{url_ext}"], GRAPE_API::TMP_FILE_PATH)
      temp_file.write rsq_body.force_encoding("UTF-8")
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
