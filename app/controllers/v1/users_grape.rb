module V1
  # user apis
  class UsersGrape < SignGrape
    desc '单点登录' do
      summary '单点登录'
      detail '单点登录'
      tags ['users']
      success({ code: 200, model: Entities::RecordBase, examples: { token: 'token' } })
    end
    params do
      requires :ticket, allow_blank: false, type: String
      requires :service_url, allow_blank: false, type: String
    end
    post '/sso' do
      status, resutl = CasSso.login(params[:ticket], params[:service_url])
      error_422!(resutl) unless status

      @current_user = resutl
      data!(token: Svc::JwtSignature.sign(resutl.payload))
    end

    # TODO
    params do
      requires :id, allow_blank: false, type: String
    end
    post 'sso_f' do
      @current_user = User.find(params.id || 1)
      data!(token: Svc::JwtSignature.sign(@current_user.payload))
    end

    desc '获取权限列表' do
      summary '获取权限列表'
      detail '获取权限列表'
      tags ['users']
    end
    get 'resources' do
      data!(resource_names: current_user.resource_names)
    end

    desc '单点登出' do
      summary '单点登出'
      detail '单点登出'
      tags ['users']
      success({ code: 200, model: Entities::RecordBase, examples: { token: 'token' } })
    end
    post 'logout' do
      # 1. 删除本地 token
      # 2. 跳转至 web logout
      # 3. 跳转至单点 logout
      query_params = {
        url:     "#{Settings.WEB_HOST}#{Settings.WEB_HUNDLE_LOGOUT_PATH}",
        service: "#{Settings.WEB_HOST}#{Settings.WEB_HUNDLE_LOGOUT_PATH}",
      }

      login_params = {
        service: "#{Settings.WEB_HOST}",
      }

      data!(
        logout_url:    "#{Settings.SSO_HOST}#{Settings.SSO_LOGOUT_PATH}?#{query_params.to_query}",
        sso_login_url: "#{Settings.SSO_HOST}#{Settings.SSO_LOGIN_PATH}?#{login_params.to_query}",
      )
    end

    # desc '用户信息' do
    #   summary '用户信息'
    #   detail '用户信息'
    #   tags ['users']
    # end
    # get 'info' do
    #   data_record!(@current_user, Entities::User::Info)
    # end
    #
    # desc '修改用户头像' do
    #   summary '修改用户头像'
    #   detail '修改用户头像'
    #   tags ['users']
    # end
    # params do
    #   requires :avatar, type: File, desc: '头像'
    # end
    # put '/avatar' do
    #   current_user.files_avatar.update!(file: params[:avatar])
    #   data_record!(@current_user, Entities::User::Info)
    # end
  end
end
