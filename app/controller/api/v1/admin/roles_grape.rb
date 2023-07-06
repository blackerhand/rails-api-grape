module Api::V1::Admin
  class RolesGrape < Api::AdminGrape
    helpers do
      def current_scope
        Role.pure_roles
      end
    end

    desc '角色列表' do
      summary '角色列表'
      detail '角色列表'
      tags ['admin_roles']
      success Entities::Role::List
    end
    get '/' do
      @roles = current_scope.page(params.page).per(page_per)
      data_paginate!(@roles, Entities::Role::List)
    end

    desc '新增角色' do
      summary '新增角色'
      detail '新增角色'
      tags ['admin_roles']
      success Entities::Role::Detail
    end
    params do
      requires :role, type: Hash do
        string_field :name, en: true
        string_field :name_zh
        string_field :desc, optional: true, allow_blank: true
        auto_field :resource_ids, type: Array[Integer]
      end
    end
    post '/' do
      valid_error!('权限 id 不正确, 请检查重试') unless Resource.where(id: declared_params.resource_ids).count == declared_params.resource_ids.count
      valid_error!('角色名称已存在') if Role.exists?(name_zh: declared_params.name_zh)

      @role = Role.create!(declared_params.to_h)
      data_record!(@role, Entities::Role::Detail)
    end

    route_param :id, requirements: { id: /[0-9]+/ } do
      desc '角色详情' do
        summary '角色详情'
        detail '角色详情'
        tags ['admin_roles']
        success Entities::Role::Detail
      end
      get '/' do
        data_record!(current_record, Entities::Role::Detail)
      end

      desc '修改角色' do
        summary '修改角色'
        detail '修改角色'
        tags ['admin_roles']
        success Entities::Role::Detail
      end
      params do
        requires :role, type: Hash do
          string_field :name, en: true
          string_field :name_zh
          string_field :desc, optional: true, allow_blank: true
          auto_field :resource_ids, type: Array[Integer]
        end
      end
      put '/' do
        valid_error!('不允许修改超级管理员权限') unless current_record.can_modify
        valid_error!('权限 id 不正确, 请检查重试') unless Resource.where(id: declared_params.resource_ids).count == declared_params.resource_ids.count
        valid_error!('角色名称已存在') if (Role.where(name_zh: declared_params.name_zh).ids - [current_record.id]).present?

        current_record.update!(declared_params.to_h)
        data_record!(current_record, Entities::Role::Detail)
      end

      desc '删除角色' do
        summary '删除角色'
        detail '删除角色'
        tags ['admin_roles']
      end
      delete '/' do
        valid_error!('不允许修改超级管理员权限') unless current_record.can_modify

        current_record.destroy
        data!('删除成功')
      end
    end
  end
end
