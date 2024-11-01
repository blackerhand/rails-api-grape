module Api::V1::Portal
  class PostsGrape < Api::PortalGrape
    swagger_desc('get_portal_posts')
    params do
      integer_field :page, optional: true
      integer_field :per, optional: true
    end
    get '/' do
      @posts = Post.all.page(params.page).per(page_per)
      data_paginate!(@posts, namespace: 'List')
    end

    route_param :id, requirements: { id: /[0-9]+/ } do
      base.swagger_desc('get_portal_posts_id')
      get '/' do
        current_record.increment!(:click_number)
        data_records!(current_record, namespace: 'Detail')
      end
    end
  end
end
