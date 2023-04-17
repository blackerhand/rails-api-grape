GrapeSwaggerRails.options.app_name = 'API Doc'
GrapeSwaggerRails.options.app_url  = Settings.HOST
GrapeSwaggerRails.options.url      = '/api/swagger'

# GrapeSwaggerRails.options.before_action do
#   GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
# end

unless Rails.env.development?
  GrapeSwaggerRails.options.api_auth     = 'basic'
  GrapeSwaggerRails.options.api_key_name = 'Authorization'
  GrapeSwaggerRails.options.api_key_type = 'header'

  GrapeSwaggerRails.options.before_action do |request|
    authenticate_or_request_with_http_basic do |name, password|
      name == 'admin' && password == '7846e1b0119b18893j41151b280ecdf7'
    end
  end
end
