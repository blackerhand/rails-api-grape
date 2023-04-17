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

  def set_papertrail_user(current_user_id)
    ::PaperTrail.request.whodunnit = current_user_id
  end

  def not_require_login?
    GRAPE_API::NOT_REQUIRE_LOGIN.include?(action_full_name)
  end

  def resource_authorize
    raise PermissionDeniedError, '你没有权限访问此页面' unless current_user.has_resources?(action_full_name)
  end

  # 执行 pundit 验证, authorize(record, policy_method)
  # mode-require:
  # 新加一个api 以后, 需要新建一个对应的 policy 文件, 然后定义相应的授权方法
  # 例如: /v1/posts_grape.rb => get '/v1/posts/:id'
  #      需要新建 /v1/posts_policy.rb#get_posts_id?
  #      方法中可以使用 record, user 变量, 允许返回 true, 不允许返回 false
  # mode-optional:
  # 只会校验定义了 policy 的 api, 取消注释 if 即可, 不推荐
  def pundit_authorize
    policy_class_tmp = policy_class # 临时解决
    policy_record    = current_record || record_class || policy_class

    policy_record.define_singleton_method(:policy_class) { policy_class_tmp }
    authorize(policy_record, policy_method)
  rescue NoMethodError
    authorize(policy_record, 'default_author')
  end

  def verify_admin!
    raise PermissionDeniedError, '你没有权限访问此页面' unless current_user.is_a?(Admin) && current_user.enabled?
  end
end
