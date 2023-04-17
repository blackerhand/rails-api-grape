module V1
  class CoursesGrape < PubGrape
    desc '课程列表' do
      summary '课程列表'
      detail '课程列表'
      tags ['courses']
      success Entities::Course::List
    end
    params do
      optional :page, type: Integer, desc: '页码'
      optional :per, type: Integer, desc: '每页数量'
      optional :q, type: Hash do
        optional :account_id_in, desc: '学院 ID 包含'
      end
    end
    get '/' do
      @account_id_query = { account_id: params.q.account_id_in } if params.q&.account_id_in.present?
      @account_ids      = Course.state_publish.distinct(:account_id).pluck(:account_id)
      @accounts_infos   = Canvas::SubAccount.where(canvas_id: @account_ids).map { |account| account.slice(:canvas_id, :name) }

      @courses = Course.state_publish.enabled
                       .where(@account_id_query)
                       .includes(:files_course_cover)
                       .page(params.page)
                       .per(page_per)
      data_paginate!(@courses, Entities::Course::List, accounts_infos: @accounts_infos)
    end

    route_param :id, requirements: { id: /[0-9]+/ } do
      desc '课程详情' do
        summary '课程详情'
        detail '课程详情'
        tags ['courses']
        success Entities::Course::Detail
      end
      get '/' do
        current_record.increment!(:click_number)
        data_record!(current_record, Entities::Course::Detail)
      end
    end
  end
end
