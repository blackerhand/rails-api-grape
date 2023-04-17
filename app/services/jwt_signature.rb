# jwt
module JwtSignature
  # error
  class SignError < StandardError
  end

  module_function

  # rubocop:disable Style/RescueStandardError
  def verify!(token)
    token.gsub!(/^Bearer /, '') if token.to_s.start_with?('Bearer ')
    JWT.decode token, Settings.JWT_SECRET, true, algorithm: 'HS256'
  rescue JWT::ExpiredSignature
    raise SignError, '登录已失效, 请重新登录'
  rescue JWT::DecodeError
    raise SignError, '登录失败, 请重试'
  end

  def sign(payload)
    payload['exp'] = Time.current.to_i + GRAPE_API::JWT_EXP
    "Bearer #{JWT.encode payload, Settings.JWT_SECRET, 'HS256'}"
  end

  def refresh!(payload)
    sign(payload) if payload['exp'] - Time.current.to_i < GRAPE_API::JWT_REFRESH
  end

  # rubocop:enable Style/RescueStandardError
end
