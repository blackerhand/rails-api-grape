# all grape extend it
class BaseGrape < Grape::API
  # version 'v1', using: :header, vendor: 'twitter'
  format :json
  default_format :json
  content_type :json, 'application/json'

  # validator
  require './lib/validations/max_length'
  require './lib/validations/min_length'
  require './lib/validations/sensitive_filter'

  helpers ApplicationHelper, ErrorHelper, DataBuildHelper,
          CacheHelper, FieldHelper

  include Grape::Rails::Cache

  # 401
  rescue_from(SignError) { |e| auth_error!(e) }
  rescue_from(JwtSignature::SignError) { |e| auth_error!(e) }

  # 403
  rescue_from(PermissionDeniedError) { |e| permit_error!(e) }

  # 404
  rescue_from(RecordAlreadyDisabled) { |e| not_found_error!(e) }
  rescue_from(ActiveRecord::RecordNotFound) { |e| not_found_error!(e) }

  # 406
  rescue_from(ActiveRecord::RecordInvalid) { |e| valid_error!(e) }
  rescue_from(Grape::Exceptions::ValidationErrors) { |e| valid_error!(e) }
  rescue_from(ServiceCheckError) { |e| valid_error!(e) }
  rescue_from(SearchError) { |e| valid_error!(e) }
  rescue_from(GetIoFormatError) { |e| valid_error!(e) }

  # 409
  # rescue_from(AASM::InvalidTransition) { |_e| not_allow_error!('该条数据当前状态, 不允许变更为选定状态, 请检查') }
  rescue_from(RecordNotAllowDisabled) { |e| not_allow_error!(e) }
  rescue_from(RecordStateError) { |e| not_allow_error!(e) }

  # add the handle need before this code
  mount SignGrape
  mount PubGrape

  get '/' do
    { status: 'ok' }
  end

  add_swagger_documentation(
    mount_path:  '/api/swagger',
    doc_version: '0.1.0',
    host:        Settings.HOST.gsub(/(http|https):\/\//, ''),
    tags:        [
                   { name: 'static', description: '通用接口' },
                   { name: 'files', description: '文件' },
                   { name: 'users', description: '用户' },
                   { name: 'posts', description: '新闻' },
                   { name: 'grades', description: '年级' },

                   # portal
                   { name: 'portal_dashboard', description: '首页' },
                   { name: 'portal_projects', description: '案例中心' },
                   { name: 'portal_guides', description: '操作指南' },
                   { name: 'portal_grades', description: '班级' },
                   { name: 'portal_posts', description: '新闻' },

                   # admin
                   { name: 'admin_dashboard', description: 'ADMIN 通用接口, 无需鉴权' },
                   { name: 'admin_resources', description: '权限管理' },
                   { name: 'admin_roles', description: '角色管理' },
                   { name: 'admin_users', description: '学生管理' },
                   { name: 'admin_posts', description: '新闻管理' },
                   { name: 'admin_guides', description: '指南管理' },
                   { name: 'admin_grades', description: '班级管理' },
                   { name: 'admin_projects', description: '案例管理' },
                   { name: 'admin_edu_users', description: '人员管理' },
                   { name: 'admin_courses', description: '课程管理' },
                   { name: 'admin_terms', description: '学期管理' },

                   # student
                   { name: 'student_dashboard', description: '学生端首页' },
                   { name: 'student_courses', description: '学生端课程' },

                   # teacher
                   { name: 'teacher_dashboard', description: '教师端首页' },
                   { name: 'teacher_courses', description: '教师端课程' },
                 ]
  )
end
