module Entities
  module Resource
    class DetailWithChildren < Base
      expose_with_doc :id, :key, :router_path, :parent_id

      expose :meta do
        expose :i18n_title, as: :title
        expose_with_doc :key, :i18n_title, :router_path,
                        :keep_alive, :icon, :order_index, :hide,
                        :menu_type, :menu_type_name, :platform, :platform_name
      end

      expose_with_doc :children,
                      using: Entities::Resource::DetailWithChildren,
                      if:    ->(resource, _options) { resource.children.present? }
    end
  end
end
