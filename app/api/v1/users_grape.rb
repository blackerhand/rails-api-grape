module V1
  # user apis
  class UsersGrape < SignGrape
    desc '登录' do
      summary '登录'
      detail '登录'
      tags ['users']
    end
    params do
      requires :user, type: Hash do
        email_field :email
        password_field :password
      end
      bool_field :remember, default: false, desc: '记住密码'
    end
    post '/sign_in' do
      @user = User.find_by(email: declared_params.email)
      auth_error!('用户名或密码错误') if @user.nil? || !@user.authenticate(declared_params.password)

      update_current_user(@user, params.remember)
      data!(token: JwtSignature.sign(@payload))
    end

    desc '我的权限列表' do
      summary '我的权限列表'
      detail '我的权限列表'
      tags ['users']
      success({ code: 200, model: Entities::RecordBase, examples: %w[resource_key1 resource_key2] })
    end
    get '/my_resources' do
      @resources    = current_user.resources.select(:id, :key, :platform)
      resource_keys = @resources.each_with_object({}) do |result, resource|
        resource[result.platform] ||= []
        resource[result.platform] << result.key
      end

      data! resource_keys
    end

    # desc '注册' do
    #   summary '注册'
    #   detail '注册'
    #   tags ['users']
    # end
    # params do
    #   requires :user, type: Hash do
    #     requires :email, allow_blank: false, regexp: GRAPE_API::EMAIL_REGEX
    #     requires :password, allow_blank: false, type: String
    #     requires :nickname, allow_blank: false, type: String
    #   end
    # end
    # post '/sign_up' do
    #   @user = User.create!(declared_params)
    #   data!(token: JwtSignature.sign(@user.payload))
    # end
    #
    # desc '发送重置密码邮件' do
    #   summary '发送重置密码邮件'
    #   detail '发送重置密码邮件'
    #   tags ['users']
    # end
    # params do
    #   requires :user, type: Hash do
    #     requires :email, allow_blank: false, regexp: GRAPE_API::EMAIL_REGEX
    #   end
    # end
    # post '/send_mail' do
    #   render_service! Users::ResetPasswdMail.execute(declared_params.email)
    # end
    #
    # desc '重置密码' do
    #   summary '重置密码'
    #   detail '重置密码'
    #   tags ['users']
    # end
    # params do
    #   requires :user, type: Hash do
    #     requires :email, allow_blank: false, regexp: GRAPE_API::EMAIL_REGEX
    #     requires :code, regexp: /^\d{6}$/
    #     requires :password, allow_blank: false, min_length: 6, type: String
    #   end
    # end
    # post '/reset' do
    #   @user = User.find_by(email: declared_params.email)
    #   auth_error!('邮箱不存在') if @user.nil?
    #   auth_error!('验证码不正确') unless @user.code == declared_params.code
    #
    #   @user.update!(password: declared_params.password, code: nil)
    #   data!(token: JwtSignature.sign(@user.payload))
    # end
    #
    # desc '获取权限列表' do
    #   summary '获取权限列表'
    #   detail '获取权限列表'
    #   tags ['users']
    # end
    # get 'resources' do
    #   data!(resource_keys: current_user.resource_keys)
    # end
    #
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
    #   requires :user, type: Hash do
    #     requires :avatar, type: File, desc: '头像'
    #   end
    # end
    # put '/avatar' do
    #   current_user.files_avatar.update!(file: declared_params.avatar)
    #   data_record!(@current_user, Entities::User::Info)
    # end
  end
end
