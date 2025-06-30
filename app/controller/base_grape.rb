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
  require './lib/validations/id_card'

  helpers ApplicationHelper, ErrorHelper, DataBuildHelper,
          CacheHelper, FieldHelper, ValidHelper,
          ParamsHelper, ResourceHelper, GrapeParamsHelper

  # include Grape::Rails::Cache
  include SwaggerHelper

  # 401
  rescue_from(SignError) { |e| auth_error!(e) }
  rescue_from(JwtSignature::SignError) { |e| auth_error!(e) }

  # 403
  rescue_from(PermissionDeniedError) { |e| permit_error!(e) }

  # 404
  rescue_from(RecordAlreadyDisabled) { |e| not_found_error!(e) }
  rescue_from(ActiveRecord::RecordNotFound) { |e| not_found_error!(e) }

  # 406
  # rescue_from(ActiveRecord::RecordNotUnique) { |e| valid_error!(e) }
  rescue_from(ActiveRecord::RecordInvalid) { |e| valid_error!(e) }
  rescue_from(Grape::Exceptions::ValidationErrors) { |e| valid_error!(e) }
  rescue_from(ServiceCheckError) { |e| valid_error!(e) }
  rescue_from(SearchError) { |e| valid_error!(e) }
  rescue_from(GetIoFormatError) { |e| valid_error!(e) }

  # 409
  # rescue_from(AASM::InvalidTransition) { |_e| not_allow_error!('该条数据当前状态, 不允许变更为选定状态, 请检查') }
  rescue_from(RecordNotAllowDisabled) { |e| not_allow_error!(e) }
  rescue_from(RecordStateError) { |e| not_allow_error!(e) }

  # 422
  rescue_from(WxaError) { |e| error_422!(e) }

  mount Api::PubGrape
  mount Api::SignGrape

  add_swagger_documentation(
    mount_path:  '/api/swagger',
    doc_version: '0.1.0',
    host:        Settings.HOST.gsub(/(http|https):\/\//, ''),
    tags:        [
                   { name: 'static', description: '通用接口' },
                   { name: 'files', description: '文件' },
                   { name: 'users_auth', description: '用户登录' },
                   { name: 'posts', description: '新闻' },

                   # portal
                   { name: 'portal_dashboard', description: '首页' },
                   { name: 'portal_posts', description: '新闻' },

                   # admin
                   { name: 'admin_dashboard', description: 'ADMIN 通用接口, 无需鉴权' },
                   { name: 'admin_resources', description: '权限管理' },
                   { name: 'admin_roles', description: '角色管理' },
                   { name: 'admin_posts', description: '新闻管理' },
                 ])
end
