module Api::V1::Portal
  class DashboardGrape < Api::PortalGrape
    swagger_desc('get_portal')
    get '/' do
      @posts = Post.enabled.limit(4)

      data!({
              posts: json_records!(@posts, Entities::Post::List),
            })
    end
  end
end
