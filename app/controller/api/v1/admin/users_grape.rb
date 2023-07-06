module Api::V1::Admin
  class UsersGrape < Api::AdminGrape
    desc '用户列表' do
      summary '用户列表'
      detail '用户列表'
      tags ['admin_users']
      success Entities::User::Info
    end
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

    desc '新增用户' do
      summary '新增用户'
      detail '新增用户'
      tags ['admin_users']
    end
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
      desc '用户详情' do
        summary '用户详情'
        detail '用户详情'
        tags ['admin_users']
      end
      get '/' do
        data_record!(current_record, Entities::User::Detail)
      end

      desc '修改用户' do
        summary '修改用户'
        detail '修改用户'
        tags ['admin_users']
      end
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

      desc '删除用户' do
        summary '删除用户'
        detail '删除用户'
        tags ['admin_users']
      end
      delete '/' do
        current_record.disable!
        data!('删除成功')
      end
    end
  end
end
