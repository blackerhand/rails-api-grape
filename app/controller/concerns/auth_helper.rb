# helpers for sign grape
module AuthHelper
  def parse_current_user
    return if request.headers['Authorization'].blank?

    @payload       = JwtSignature.verify!(request.headers['Authorization']).first
    @current_user  = User.build_with!(@payload)
    @refresh_token = JwtSignature.refresh!(@payload)

    # 为了避免重复查询数据库，这里暂不更新 payload, 所以更新权限后需要重新登录
    # @payload       = payload.merge(@current_user.payload)
  end

  def parse_jwt!
    return if not_require_login? && request.headers['Authorization'].blank?
    raise SignError, I18n.t_message('please_login') if request.headers['Authorization'].blank?

    parse_current_user
    raise SignError, I18n.t_message('login_error') if @current_user.nil?

    set_papertrail_user(current_user_id)
  end

  def set_papertrail_user(current_user_id)
    ::PaperTrail.request.whodunnit = current_user_id
  end

  def not_require_login?
    GRAPE_API::NOT_REQUIRE_LOGIN.include?(action_full_name)
  end

  def resource_authorize
    return if controller_name.to_s == 'dashboard'

    raise PermissionDeniedError, I18n.t_message('page_no_permission') unless current_user.resources?(action_full_name)
  end

  def verify_admin!
    raise PermissionDeniedError, I18n.t_message('page_no_permission') unless current_user.can_access_admin
  end
end
