# frozen_string_literal: true

module V1
  module Admin
    class RolesGrape < AdminGrape
      desc '角色列表' do
        summary '角色列表'
        detail '角色列表'
        tags ['admin_roles']
        success Entities::Role::List
      end
      get '/' do
        @roles = Role.enabled.pure_roles.page(params.page).per(page_per)
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
          requires :name, max_length: GRAPE_API::MAX_STRING_LENGTH, regexp: GRAPE_API::REQUIRES_EN_REGEX, type: String, allow_blank: false, desc: '角色标识'
          requires :name_zh, max_length: GRAPE_API::MAX_STRING_LENGTH, type: String, allow_blank: false, desc: '名称'
          optional :desc, max_length: GRAPE_API::MAX_STRING_LENGTH, type: String, allow_blank: true, desc: '角色介绍'
          requires :resource_ids, type: Array[Integer], desc: '权限id列表'
        end
      end
      post '/' do
        role_attrs = declared_params.role

        valid_error!('权限 id 不正确, 请检查重试') unless Resource.where(id: role_attrs.resource_ids).count == role_attrs.resource_ids.count
        valid_error!('角色名称已存在') if Role.exists?(name_zh: role_attrs.name_zh)

        @role = Role.create!(role_attrs.to_h)
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
            requires :name, max_length: GRAPE_API::MAX_STRING_LENGTH, regexp: GRAPE_API::REQUIRES_EN_REGEX, type: String, allow_blank: false, desc: '角色标识'
            requires :name_zh, max_length: GRAPE_API::MAX_STRING_LENGTH, type: String, allow_blank: false, desc: '名称'
            optional :desc, max_length: GRAPE_API::MAX_STRING_LENGTH, type: String, allow_blank: true, desc: '角色介绍'
            requires :resource_ids, type: Array[Integer], desc: '权限id列表'
          end
        end
        put '/' do
          role_attrs = declared_params.role
          valid_error!('不允许修改超级管理员权限') unless current_record.can_modify
          valid_error!('权限 id 不正确, 请检查重试') unless Resource.where(id: role_attrs.resource_ids).count == role_attrs.resource_ids.count
          valid_error!('角色名称已存在') if (Role.where(name_zh: role_attrs.name_zh).ids - [current_record.id]).present?

          current_record.update!(role_attrs.to_h)
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
end
