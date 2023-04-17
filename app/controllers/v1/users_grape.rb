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
