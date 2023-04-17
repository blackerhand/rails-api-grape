module V1
  module Admin
    class GuidesGrape < AdminGrape
      desc '指南列表' do
        summary '指南列表'
        detail '指南列表'
        tags ['admin_guides']
        success Entities::Guide::List
      end
      get '/' do
        @guides = Guide.enabled.page(params.page).per(page_per)
        data_paginate!(@guides, Entities::Guide::List)
      end

      desc '新增指南' do
        summary '新增指南'
        detail '新增指南'
        tags ['admin_guides']
        success Entities::Guide::Detail
      end
      params do
        requires :guide, type: Hash do
          requires :title, type: String, allow_blank: false, max_length: GRAPE_API::MAX_STRING_LENGTH, desc: '名称'
          requires :desc, type: String, allow_blank: false, max_length: GRAPE_API::MAX_STRING_LENGTH, desc: '指南详情'
          requires :icon, type: String, allow_blank: true, max_length: GRAPE_API::MAX_STRING_LENGTH, desc: '指南图标'
          optional :files_guide, type: File, allow_blank: true, desc: '指南文件'
        end
      end
      post '/' do
        guide_attrs = declared_params.guide

        @guide = Guide.create!(guide_attrs.slice('title', 'desc', 'icon'))
        if guide_attrs.files_guide.present?
          @guide.files_guide.file = guide_attrs.files_guide
          @guide.files_guide.save!
        end

        data_record!(@guide, Entities::Guide::Detail)
      end

      route_param :id, requirements: { id: /[0-9]+/ } do
        desc '指南详情' do
          summary '指南详情'
          detail '指南详情'
          tags ['admin_guides']
          success Entities::Guide::Detail
        end
        get '/' do
          data_record!(current_record, Entities::Guide::Detail)
        end

        desc '修改指南' do
          summary '修改指南'
          detail '修改指南'
          tags ['admin_guides']
          success Entities::Post::Detail
        end
        params do
          requires :guide, type: Hash do
            requires :title, type: String, allow_blank: false, max_length: GRAPE_API::MAX_STRING_LENGTH, desc: '名称'
            requires :desc, type: String, allow_blank: false, max_length: GRAPE_API::MAX_TEXT_LENGTH, desc: '指南详情'
            requires :icon, type: String, allow_blank: true, max_length: GRAPE_API::MAX_STRING_LENGTH, desc: '指南图标'
            # optional :files_guide, type: File, allow_blank: true, desc: '指南文件'
          end
        end
        put '/' do
          guide_attrs = declared_params.guide
          current_record.update!(guide_attrs.slice('title', 'desc', 'icon'))
          # current_record.files_guide.file = guide_attrs.files_guide
          # current_record.files_guide.save!

          data_record!(current_record, Entities::Guide::Detail)
        end

        desc '修改指南文件' do
          summary '修改指南文件'
          detail '修改指南文件'
          tags ['admin_guides']
          success Entities::Post::Detail
        end
        params do
          optional :guide, type: Hash do
            optional :files_guide, type: File, allow_blank: true, desc: '指南文件'
          end
        end
        post '/files_guide' do
          current_record.files_guide.file = declared_params&.guide&.files_guide
          current_record.files_guide.save!

          data_record!(current_record, Entities::Guide::Detail)
        end

        desc '删除指南' do
          summary '删除指南'
          detail '删除指南'
          tags ['admin_guides']
        end
        delete '/' do
          current_record.disabled!
          data!('删除成功')
        end
      end
    end
  end
end
