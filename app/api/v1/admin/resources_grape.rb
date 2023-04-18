module V1
  module Admin
    class ResourcesGrape < AdminGrape
      helpers do
        def resource_tree(hash)
          hash.each.map do |k, v|
            attrs            = Entities::Resource::Detail.represent(k).as_json
            attrs[:children] = resource_tree(v) if v.present?

            attrs
          end
        end
      end

      desc '权限列表' do
        summary '权限列表'
        detail '权限列表'
        tags ['admin_resources']
      end
      get '/' do
        resource_tree Resource.arrange
      end
    end
  end
end
