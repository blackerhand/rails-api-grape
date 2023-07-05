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
end
