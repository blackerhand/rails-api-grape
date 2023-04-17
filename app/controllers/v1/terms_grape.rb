module V1
  class TermsGrape < PubGrape
    desc '学期列表' do
      summary '学期列表'
      detail '学期列表'
      tags ['totals']
      success Entities::CanvasTerm::List
    end
    params do
      optional :page, type: Integer, desc: '页码'
      optional :per, type: Integer, desc: '每页数量'
    end
    get '/' do
      @posts = Canvas::Term.enabled.reorder(id: :asc).page(params.page).per(page_per)
      data_paginate!(@posts, Entities::CanvasTerm::List)
    end
  end
end
