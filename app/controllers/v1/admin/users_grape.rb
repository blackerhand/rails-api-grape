module V1
  module Admin
    class UsersGrape < AdminGrape
      desc '用户列表' do
        summary '用户列表'
        detail '用户列表'
        tags ['admin_users']
      end
      params do
        optional :q, type: Hash do
          optional :id_eq, type: String, desc: '用户 ID 等于'
          optional :nickname_cont, type: String, desc: '用户姓名模糊匹配'
          optional :sis_user_id_eq, type: String, desc: '学号等于'
          optional :type_eq, type: String, desc: '用户身份等于'
          optional :can_access_totals_eq, type: Boolean, desc: '是否可以访问数据看板'
        end
      end
      get '/' do
        @search = User.all.ransack(params.q)
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
          requires :sis_user_id, max_length: GRAPE_API::MAX_STRING_LENGTH, regexp: GRAPE_API::REQUIRES_EN_1_REGEX, type: String, allow_blank: false
          requires :nickname, max_length: GRAPE_API::MAX_STRING_LENGTH, type: String, allow_blank: false
          optional :type, type: String, values: GRAPE_API::USER_TYPES, default: 'User'
          optional :role_ids, type: Array
        end
      end
      post '/' do
        @user = User.create!(declared_params.user.to_h)
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
            requires :nickname, type: String, max_length: GRAPE_API::MAX_STRING_LENGTH, allow_blank: false
            optional :type, type: String, values: GRAPE_API::USER_TYPES, default: 'User'
            optional :role_ids, type: Array
          end
        end
        put '/' do
          user_attrs = declared_params.user
          valid_error!('角色 ID 不正确, 请检查重试') if user_attrs.role_ids.present? && Role.where(id: user_attrs.role_ids).count != user_attrs.role_ids.count
          # valid_error!('不允许修改自己的权限') if declared_params.key?('role_ids') && current_record.id == current_user.id

          current_record.update!(user_attrs.to_hash)
          data_record!(current_record, Entities::User::Detail)
        end
      end
    end
  end
end
