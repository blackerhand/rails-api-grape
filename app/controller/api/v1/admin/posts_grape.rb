module Api::V1::Admin
  class PostsGrape < Api::AdminGrape
    swagger_desc('get_admin_posts')
    get '/' do
      @posts = Post.page(params.page).per(page_per)
      data_paginate!(@posts, namespace: 'List')
    end

    swagger_desc('post_admin_posts')
    params do
      requires :post, type: Hash do
        string_field :title
        text_field :desc
      end
    end
    post '/' do
      @post = Post.create!(declared_params.to_h)
      data_record!(@post, namespace: 'List')
    end

    route_param :id, requirements: { id: /[0-9]+/ } do
      base.swagger_desc('get_admin_posts_id')
      get '/' do
        data_record!(current_record, namespace: 'Detail')
      end

      base.swagger_desc('put_admin_posts_id')
      params do
        requires :post, type: Hash do
          string_field :title
          text_field :desc
        end
      end
      put '/' do
        current_record.update!(declared_params.to_h)
        data_record!(current_record, namespace: 'Detail')
      end

      base.swagger_desc('delete_admin_posts_id')
      delete '/' do
        current_record.destroy!
        data_message!('delete_success')
      end
    end
  end
end
