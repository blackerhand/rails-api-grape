module V1
  module Admin
    class CoursesGrape < AdminGrape
      desc '课程列表' do
        summary '课程列表'
        detail '课程列表'
        tags ['admin_courses']
        success Entities::Course::AdminList
      end
      params do
        optional :q, type: Hash do
          optional :name_cont, type: String, desc: '课程名称'
          optional :state_eq, values: Course.states.keys, type: String, desc: '课程状态'
          optional :course_code_eq, type: String, desc: '课程代码'
          optional :need_audit_eq, type: Boolean, desc: '是否有待审核变更'
          optional :canvas_id_eq, type: Integer, desc: 'canvas 系统 id'
          optional :account_id_eq, type: Integer, desc: '子账户 id'
          optional :term_id_eq, type: Boolean, desc: '学期 id'
        end
      end
      get '/' do
        @search  = Course.all.ransack(params.q)
        @courses = @search.result.page(params.page).per(page_per)
        data_paginate! @courses, Entities::Course::AdminList
      end

      desc '手动同步课程变更' do
        summary '手动同步课程变更'
        detail '手动同步课程变更'
        tags ['admin_courses']
      end
      params do
        requires :course, type: Hash do
          requires :canvas_id, type: Integer, max_length: GRAPE_API::MAX_STRING_LENGTH, allow_blank: false
        end
      end
      post '/sync' do
        FetchCanvasCourseJob.perform_later(params.course.canvas_id)
        data!('添加任务成功, 请等待任务完成后刷新页面')
      end

      route_param :id, requirements: { id: /[0-9]+/ } do
        desc '课程详情' do
          summary '课程详情'
          detail '课程详情'
          tags ['admin_courses']
          success Entities::Course::AdminDetail
        end
        get '/' do
          data_record!(current_record, Entities::Course::AdminDetail)
        end

        desc '修改课程' do
          summary '修改课程'
          detail '修改课程'
          tags ['admin_courses']
          success Entities::Course::AdminDetail
        end
        params do
          requires :course, type: Hash do
            requires :state, type: String, values: Course.states.keys
          end
        end
        put '/' do
          current_record.update!(declared_params.course)
          data_record!(current_record, Entities::Course::AdminDetail)
        end
      end
    end
  end
end
