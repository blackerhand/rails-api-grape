module Api::V1::Admin
  class UsersGrape < Api::AdminGrape
    helpers do
      def current_scope
        User.all
      end
    end

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
      data_paginate! @users, namespace: 'List'
    end

    swagger_desc('post_admin_users')
    params do
      requires :user, type: Hash do
        email_field :email, optional: true
        string_field :nickname
        enum_field :user_type, values: GRAPE_API::USER_TYPES, default: 'User'
        array_field :role_ids, optional: true
      end
    end
    post '/' do
      valid_ids!(declared_params.role_ids, Role)

      @user = Users::Update.execute(User.new, declared_params).record
      data_record!(@user, namespace: 'List')
    end

    route_param :id, requirements: { id: /[0-9]+/ } do
      base.swagger_desc('get_admin_users_id')
      get '/' do
        data_record!(current_record, namespace: 'Detail')
      end

      base.swagger_desc('put_admin_users_id')
      params do
        requires :user, type: Hash do
          email_field :email, optional: true
          string_field :nickname
          enum_field :user_type, values: GRAPE_API::USER_TYPES, default: 'User'
          array_field :role_ids, optional: true
        end
      end
      put '/' do
        valid_ids!(declared_params.role_ids, Role)

        Users::Update.execute(current_record, declared_params)
        data_record!(current_record, namespace: 'Detail')
      end

      base.swagger_desc('delete_admin_users_id')
      delete '/' do
        current_record.destroy!
        data_message!('delete_success')
      end
    end
  end
end
