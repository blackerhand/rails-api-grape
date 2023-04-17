module V1
  class PostsGrape < PubGrape
    desc '新闻列表页' do
      summary '新闻列表页'
      detail '新闻列表页'
      tags ['posts']
      success Entities::Post::List
    end
    params do
      optional :page, type: Integer, desc: '页码'
      optional :per, type: Integer, desc: '每页数量'
    end
    get '/' do
      @posts = Post.enabled.page(params.page).per(page_per)
      data_paginate!(@posts, Entities::Post::List)
    end

    route_param :id, requirements: { id: /[0-9]+/ } do
      desc '新闻详情' do
        summary '新闻详情'
        detail '新闻详情'
        tags ['posts']
        success Entities::Post::Detail
      end
      get '/' do
        current_record.increment!(:click_number)
        data_record!(current_record, Entities::Post::Detail)
      end
    end
  end
end
