# jwt
module JwtSignature
  # error
  class SignError < StandardError
  end

  module_function

  def verify!(token)
    token.gsub!(/^Bearer /, '') if token.to_s.start_with?('Bearer ')
    JWT.decode token, Settings.JWT_SECRET, true, algorithm: 'HS256'
  rescue JWT::ExpiredSignature
    raise SignError, I18n.t_message('jwt_expired_error')
  rescue JWT::DecodeError
    raise SignError, I18n.t_message('jwt_decode_error')
  end

  def sign(payload)
    payload['exp'] = Time.current.to_i + exp_seconds(payload)
    "Bearer #{JWT.encode payload, Settings.JWT_SECRET, 'HS256'}"
  end

  def exp_seconds(payload)
    payload['remember'] ? GRAPE_API::JWT_REM_EXP : GRAPE_API::JWT_EXP
  end

  def refresh?(payload)
    token_create_time = Time.zone.at(payload['exp']) - exp_seconds(payload)
    Time.current - token_create_time > GRAPE_API::JWT_REFRESH
  end

  def refresh!(payload)
    sign(payload) if refresh?(payload)
  end
end
