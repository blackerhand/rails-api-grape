module Api::V1::Users
  class DashboardGrape < Api::UsersGrape
    swagger_desc('get_users_dashboard')
    get '/' do
      { status: 'ok' }
    end

    swagger_desc('get_users_info')
    get '/info' do
      data_records! current_user, namespace: 'List'
    end

    swagger_desc('post_users_info')
    params do
      requires :user, type: Hash do
        email_field :email, desc: '邮箱', optional: true
        password_field :password, desc: '密码', optional: true
        string_field :description, desc: '描述', optional: true
        integer_field :files_avatar_id, desc: '头像ID', optional: true
      end
    end
    post '/info' do
      current_user.update!(declared_params(:user))
      data_records! current_user, namespace: 'List'
    end

    swagger_desc('put_global_settings')
    params do
      requires :global_setting, type: Hash do
        string_field :key
        text_field :value, type: String, optional: true
        array_field :files_setting_file_ids, type: Array, optional: true
      end
    end
    put '/global_settings' do
      ActiveRecord::Base.transaction do
        attrs           = declared_params(:global_setting)
        @global_setting = GlobalSetting.set(key: attrs[:key], value: attrs[:value], user_id: current_user.id,)
        @global_setting.update!(attrs)
      end

      data_records! @global_setting, namespace: 'List'
    end
  end
end
