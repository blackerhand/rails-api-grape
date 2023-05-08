# helpers for sign grape
module AuthHelper
  def parse_current_user
    return if request.headers['Authorization'].blank?

    payload        = JwtSignature.verify!(request.headers['Authorization']).first
    @current_user  = User.build_with!(payload)
    @refresh_token = JwtSignature.refresh!(payload)
    @payload       = payload.merge(@current_user.payload)
  end

  def parse_jwt!
    return if not_require_login? && request.headers['Authorization'].blank?
    raise SignError, '请登录' if request.headers['Authorization'].blank?

    parse_current_user
    raise SignError, '登录失败, 请重新登录' if @current_user.nil?

    set_papertrail_user(current_user_id)
  end

  def set_papertrail_user=(current_user_id)
    ::PaperTrail.request.whodunnit = current_user_id
  end

  def not_require_login?
    GRAPE_API::NOT_REQUIRE_LOGIN.include?(action_full_name)
  end

  def resource_authorize
    raise PermissionDeniedError, '你没有权限访问此页面' unless current_user.resources?(action_full_name)
  end

  def verify_admin!
    raise PermissionDeniedError, '你没有权限访问此页面' unless current_user.is_a?(Admin) && current_user.enabled?
  end
end
