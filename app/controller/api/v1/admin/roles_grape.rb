module Api::V1::Admin
  class RolesGrape < Api::AdminGrape
    helpers do
      def current_scope
        Role.pure_roles
      end
    end

    swagger_desc('get_admin_roles')
    get '/' do
      @roles = current_scope.page(params.page).per(page_per)
      data_paginate!(@roles, Entities::Role::List)
    end

    swagger_desc('post_admin_roles')
    params do
      requires :role, type: Hash do
        string_field :name, en: true
        string_field :name_zh
        string_field :desc, optional: true, allow_blank: true
        auto_field :resource_ids, type: Array[Integer]
      end
    end
    post '/' do
      valid_ids!(declared_params.resource_ids, Resource)

      @role = Role.create!(declared_params.to_h)
      data_record!(@role, Entities::Role::Detail)
    end

    route_param :id, requirements: { id: /[0-9]+/ } do
      base.swagger_desc('get_admin_roles_id')
      get '/' do
        data_record!(current_record, Entities::Role::Detail)
      end

      base.swagger_desc('put_admin_roles_id')
      params do
        requires :role, type: Hash do
          string_field :name, en: true
          string_field :name_zh
          string_field :desc, optional: true, allow_blank: true
          auto_field :resource_ids, type: Array[Integer]
        end
      end
      put '/' do
        valid_error!('cant_modify_super_admin') unless current_record.can_modify
        valid_ids!(declared_params.resource_ids, Resource)

        current_record.update!(declared_params.to_h)
        data_record!(current_record, Entities::Role::Detail)
      end

      base.swagger_desc('delete_admin_roles_id')
      delete '/' do
        valid_error!('cant_modify_super_admin') unless current_record.can_modify

        current_record.destroy
        data_message!('delete_success')
      end
    end
  end
end
