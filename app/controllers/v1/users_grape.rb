module V1
  # user apis
  class UsersGrape < SignGrape
    params do
      requires :id, allow_blank: false, type: String
    end
    post 'sso_f' do
      @current_user = User.find(params.id || 1)
      data!(token: JwtSignature.sign(@current_user.payload))
    end

    desc '登录' do
      summary '登录'
      detail '登录'
      tags ['users']
    end
    params do
      requires :email, allow_blank: false, regexp: GRAPE_API::EMAIL_REGEX
      requires :passwd, type: String
    end
    post '/sign_in' do
      @user = User.find_by(email: params[:email])

      auth_error!('邮箱不存在') if @user.nil?
      auth_error!('密码不正确') unless @user.authenticate(params[:passwd])
      @payload = @user.payload

      data!(token: JwtSignature.sign(@user.payload))
    end

    desc '注册' do
      summary '注册'
      detail '注册'
      tags ['users']
    end
    params do
      requires :email, allow_blank: false, regexp: GRAPE_API::EMAIL_REGEX
      requires :passwd, type: String
      requires :nickname, :passwd, allow_blank: false, type: String
    end
    post '/sign_up' do
      @user = User.create!(email: params[:email], nickname: params[:nickname], password: params[:passwd])
      data!(token: JwtSignature.sign(@user.payload))
    end

    desc '发送重置密码邮件' do
      summary '发送重置密码邮件'
      detail '发送重置密码邮件'
      tags ['users']
    end
    params do
      requires :email, allow_blank: false, regexp: GRAPE_API::EMAIL_REGEX
    end
    post '/send_mail' do
      render_service! Users::ResetPasswdMail.execute(params[:email])
    end

    desc '重置密码' do
      summary '重置密码'
      detail '重置密码'
      tags ['users']
    end
    params do
      requires :email, allow_blank: false, regexp: GRAPE_API::EMAIL_REGEX
      requires :code, regexp: /^\d{6}$/
      requires :passwd, type: String
    end
    post '/reset' do
      @user = User.find_by(email: params[:email])
      auth_error!('邮箱不存在') if @user.nil?
      auth_error!('验证码不正确') unless @user.code == params[:code]

      @user.update!(password: params[:passwd], code: nil)
      data!(token: JwtSignature.sign(@user.payload))
    end

    desc '获取权限列表' do
      summary '获取权限列表'
      detail '获取权限列表'
      tags ['users']
    end
    get 'resources' do
      data!(resource_names: current_user.resource_names)
    end

    desc '用户信息' do
      summary '用户信息'
      detail '用户信息'
      tags ['users']
    end
    get 'info' do
      data_record!(@current_user, Entities::User::Info)
    end

    desc '修改用户头像' do
      summary '修改用户头像'
      detail '修改用户头像'
      tags ['users']
    end
    params do
      requires :avatar, type: File, desc: '头像'
    end
    put '/avatar' do
      current_user.files_avatar.update!(file: params[:avatar])
      data_record!(@current_user, Entities::User::Info)
    end
  end
end
