# == Schema Information
#
# Table name: http_logs
#
#  id                                                                                       :bigint           not null, primary key
#  cache_response(是否缓存请求)                                                             :integer
#  client_type(请求类型)                                                                    :string(80)
#  data(body, get/delete 为空)                                                              :text(65535)
#  data_type(data 参数类型 (form/json))                                                     :string(10)
#  disabled_at                                                                              :datetime
#  force(忽略缓存, 强制请求)                                                                :boolean
#  headers(请求 header)                                                                     :text(65535)
#  http_method(请求方法)                                                                    :string(10)
#  is_system(是否系统请求)                                                                  :boolean          default(FALSE)
#  other_params(其他自定义参数, 用于构建 query_params/data_type)                            :text(65535)
#  query_params(url 参数)                                                                   :text(65535)
#  request_digest(请求唯一 id)                                                              :string(80)
#  request_valid(请求是否符合规范, 若为 false, 不会发起请求)                                :boolean
#  requestable_type(外键 类型)                                                              :string(255)
#  response(response body)                                                                  :text(65535)
#  response_code(response code)                                                             :integer
#  response_data(格式化后的 response)                                                       :text(65535)
#  response_headers(response header)                                                        :text(65535)
#  response_valid(请求结果 true/false, 这个要根据业务逻辑来设定. 不能靠 status_code 来确定) :boolean
#  retry_times(重试次数)                                                                    :integer
#  status_code(response http code)                                                          :integer
#  url(请求 URL)                                                                            :text(65535)
#  created_at                                                                               :datetime         not null
#  updated_at                                                                               :datetime         not null
#  created_user_id                                                                          :bigint
#  parent_id                                                                                :integer
#  requestable_id(外键 ID)                                                                  :string(255)
#  updated_user_id                                                                          :bigint
#
# Indexes
#
#  index_http_logs_on_client_type                    (client_type)
#  index_http_logs_on_created_at_and_client_type     (created_at,client_type)
#  index_http_logs_on_created_at_and_response_valid  (created_at,response_valid)
#  index_http_logs_on_created_user_id                (created_user_id)
#  index_http_logs_on_disabled_at                    (disabled_at)
#  index_http_logs_on_request_digest                 (request_digest)
#
class HttpLog < HttpStore::HttpLog
  include Disable

  def client_type_desc
    return if client_type.blank?

    I18n.t("activerecord.attributes.http_log.client_type_names.#{client_type}")
  end

  def format_response
    status_code <= 200 ? I18n.t_message('http_log_request_success') : I18n.t_message('http_log_request_error')
  end
end
