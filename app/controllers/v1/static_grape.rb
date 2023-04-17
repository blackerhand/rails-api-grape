module V1
  class StaticGrape < PubGrape
    desc '首页' do
      summary '首页'
      detail '首页'
      tags ['static']
      # success({ code: 200, model: Entities::RecordBase, examples: {
      #   banners:    '头图',
      #   courses:    '课程',
      #   posts:      '新闻',
      #   fix_guides: '固定操作指南',
      #   guides:     '操作指南'
      # } })
    end
    get '/' do
      # @courses    = Course.enabled.state_publish.includes(:files_course_cover).limit(12)
      # @posts      = Post.enabled.limit(8)
      # @guides     = Guide.enabled.limit(8)
      # @fix_guides = Guide.enabled.where(id: [1, 2, 3, 4, 5, 6])
      #
      # data!({
      #         sso_url:        Settings.SSO_HOST + Settings.SSO_LOGIN_PATH,
      #         canvas_sso_url: Settings.CANVAS_SSO_URL,
      #         banners:        [{ cover_url: '/uploads/files/avatar/file/4/4.png' }],
      #         courses:        json_records!(@courses, Entities::Course::List),
      #         fix_guides:     json_records!(@fix_guides, Entities::Guide::FixList),
      #         posts:          json_records!(@posts, Entities::Post::List),
      #         guides:         json_records!(@guides, Entities::Guide::List),
      #       })

      {a: 12}
    end
  end
end
