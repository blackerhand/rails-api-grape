module Api::V1::Admin
  class UsersGrape < Api::AdminGrape
    swagger_desc('get_admin_users')
    params do
      optional :q, type: Hash do
        string_field :id_eq, optional: true, desc: '用户 ID 等于'
        string_field :nickname_cont, optional: true, desc: '用户姓名模糊匹配'
        string_field :email_cont, optional: true, desc: '邮箱模糊匹配'
        string_field :type_eq, optional: true, desc: '用户身份等于'
      end
    end
    get '/' do
      @search = current_scope.ransack(params.q)
      @users  = @search.result.page(params.page).per(page_per)
      data_paginate! @users, Entities::User::Info
    end

    swagger_desc('post_admin_users')
    params do
      requires :user, type: Hash do
        string_field :nickname
        email_field :email
        password_field :password
      end
    end
    post '/' do
      @user = User.create!(declared_params.to_h)
      data_record!(@user, Entities::User::Info)
    end

    route_param :id, requirements: { id: /[0-9]+/ } do
      base.swagger_desc('get_admin_users_id')
      get '/' do
        data_record!(current_record, Entities::User::Detail)
      end

      base.swagger_desc('put_admin_users_id')
      params do
        requires :user, type: Hash do
          string_field :nickname
          email_field :email
          password_field :password, optional: true
        end
      end
      put '/' do
        current_record.update!(declared_params.to_hash)
        data_record!(current_record, Entities::User::Detail)
      end

      base.swagger_desc('delete_admin_users_id')
      delete '/' do
        current_record.disable!
        data_message!('delete_success')
      end
    end
  end
end
