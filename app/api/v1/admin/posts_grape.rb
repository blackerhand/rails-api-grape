module V1
  module Admin
    class PostsGrape < AdminGrape
      desc '新闻列表' do
        summary '新闻列表'
        detail '新闻列表'
        tags ['admin_posts']
        success Entities::Post::List
      end
      get '/' do
        @posts = Post.enabled.page(params.page).per(page_per)
        data_paginate!(@posts, Entities::Post::List)
      end

      desc '新增新闻' do
        summary '新增新闻'
        detail '新增新闻'
        tags ['admin_posts']
        success Entities::Post::Detail
      end
      params do
        requires :post, type: Hash do
          requires :title, type: String, max_length: GRAPE_API::MAX_STRING_LENGTH, allow_blank: false, desc: '名称'
          requires :desc, type: String, max_length: GRAPE_API::MAX_TEXT_LENGTH, allow_blank: false, desc: '新闻详情'
        end
      end
      post '/' do
        @post = Post.create!(declared_params.post.to_h)
        data_record!(@post, Entities::Post::Detail)
      end

      route_param :id, requirements: { id: /[0-9]+/ } do
        desc '新闻详情' do
          summary '新闻详情'
          detail '新闻详情'
          tags ['admin_posts']
          success Entities::Post::Detail
        end
        get '/' do
          data_record!(current_record, Entities::Post::Detail)
        end

        desc '修改新闻' do
          summary '修改新闻'
          detail '修改新闻'
          tags ['admin_posts']
          success Entities::Post::Detail
        end
        params do
          requires :post, type: Hash do
            requires :title, type: String, max_length: GRAPE_API::MAX_STRING_LENGTH, allow_blank: false, desc: '名称'
            requires :desc, type: String, max_length: GRAPE_API::MAX_TEXT_LENGTH, allow_blank: false, desc: '新闻详情'
          end
        end
        put '/' do
          current_record.update!(declared_params.post.to_h)
          data_record!(current_record, Entities::Post::Detail)
        end

        desc '删除新闻' do
          summary '删除新闻'
          detail '删除新闻'
          tags ['admin_posts']
        end
        delete '/' do
          current_record.disabled!
          data!('删除成功')
        end
      end
    end
  end
end
