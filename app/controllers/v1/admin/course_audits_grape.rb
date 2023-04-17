module V1
  module Admin
    class CourseAuditsGrape < AdminGrape
      route_param :id, requirements: { id: /[0-9]+/ } do
        desc '课程变更详情' do
          summary '课程变更详情'
          detail '课程变更详情'
          tags ['admin_courses']
          success Entities::CourseAudit::Detail
        end
        get '/' do
          data_record!(current_record, Entities::CourseAudit::Detail)
        end

        desc '审核课程变更' do
          summary '审核课程变更'
          detail '审核课程变更'
          tags ['admin_courses']
          success Entities::CourseAudit::Detail
        end
        params do
          requires :state, type: String, values: CourseAudit.states.keys
        end
        post '/audit' do
          CourseService::Audit.execute(current_record, params.state, current_user)
          data_record!(current_record.reload, Entities::CourseAudit::Detail)
        end
      end
    end
  end
end
