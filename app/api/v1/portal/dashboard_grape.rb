module V1
  module Portal
    class DashboardGrape < PortalGrape
      desc '首页' do
        summary '首页'
        detail '首页'
        tags ['portal_dashboard']
        success({ code: 200, model: Entities::RecordBase, examples: {
          posts: '文章列表',
        } })
      end
      get '/' do
        @posts = Post.enabled.limit(4)

        data!({
                posts: json_records!(@posts, Entities::Post::List),
              })
      end
    end
  end
end
