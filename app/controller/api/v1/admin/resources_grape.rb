module Api::V1::Admin
  class ResourcesGrape < Api::AdminGrape
    swagger_desc('get_admin_resources')
    params do
      bool_field :include_button, optional: true, default: true, desc: '是否包含按钮权限'
    end
    get '/' do
      @resources = if full_params.include_button
                     Resource.all_resources
                   else
                     Resource.all_menus
                   end.arrange

      data! ancestry_tree(@resources, namespace: 'List')
    end

    swagger_desc('post_admin_resources')
    params do
      requires :resource, type: Hash do
        string_field :key, en: true
        string_field :i18n_title
        enum_field :menu_type, default: 'button', optional: true
        enum_field :platform, default: 'admin', optional: true

        string_field :router_path, optional: true
        string_field :icon, en: true, optional: true
        string_field :layout, optional: true
        integer_field :order_index, default: 0, optional: true
        bool_field :hide, optional: true
        bool_field :keep_alive, optional: true
        integer_field :parent_id, optional: true, allow_blank: true
      end
    end
    post '/' do
      valid_error!('父权限 ID不正确, 请检查重试') if declared_params.parent_id.present? && !Resource.valid_parents.exists?(id: declared_params.parent_id)

      @resource = Resource.create!(declared_params.to_h)
      data_record!(@resource, namespace: 'List')
    end

    route_param :id, requirements: { id: /[0-9]+/ } do
      base.swagger_desc('get_admin_resources_id')
      get '/' do
        data_record!(current_record, namespace: 'Tree')
      end

      base.swagger_desc('put_admin_resources_id')
      params do
        requires :resource, type: Hash do
          string_field :key, en: true
          string_field :i18n_title
          enum_field :menu_type, default: 'button', optional: true
          enum_field :platform, default: 'admin', optional: true

          string_field :router_path, optional: true
          string_field :icon, en: true, optional: true
          string_field :layout, optional: true
          integer_field :order_index, default: 0, optional: true
          bool_field :hide, optional: true
          bool_field :keep_alive, optional: true
          integer_field :parent_id, optional: true, allow_blank: true
        end
      end
      put '/' do
        valid_error!('父权限 ID不正确, 请检查重试') if declared_params.parent_id.present? && !Resource.valid_parents.exists?(id: declared_params.parent_id)
        valid_error!('存在子权限, 不允许设置为按钮权限, 请检查重试') if current_record.children.exists? && declared_params.menu_type == 'button'

        current_record.update!(declared_params.to_h)
        data_record!(current_record, namespace: 'List')
      end

      base.swagger_desc('delete_admin_resources_id')
      delete '/' do
        valid_error!('该权限含有子权限, 不能删除') if current_record.children.exists?

        current_record.destroy
        data_message!('delete_success')
      end
    end
  end
end
