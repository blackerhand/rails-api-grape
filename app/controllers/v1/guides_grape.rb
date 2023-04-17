module V1
  class GuidesGrape < PubGrape
    desc '操作指南列表页' do
      summary '操作指南列表页'
      detail '操作指南列表页'
      tags ['guides']
      success Entities::Guide::List
    end
    params do
      optional :page, type: Integer, desc: '页码'
      optional :per, type: Integer, desc: '每页数量'
    end
    get '/' do
      @guides = Guide.enabled.page(params.page).per(page_per)
      data_paginate!(@guides, Entities::Guide::List)
    end

    route_param :id, requirements: { id: /[0-9]+/ } do
      desc '操作指南详情' do
        summary '操作指南详情'
        detail '操作指南详情'
        tags ['guides']
        success Entities::Guide::Detail
      end
      get '/' do
        current_record.increment!(:click_number)
        data_record!(current_record, Entities::Guide::Detail)
      end
    end
  end
end
