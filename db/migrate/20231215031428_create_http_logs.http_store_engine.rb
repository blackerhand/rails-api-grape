# This migration comes from http_store_engine (originally 1)
class CreateHttpLogs < ActiveRecord::Migration[7.0]
  def change
    create_table "http_logs" do |t|
      # request
      t.string :http_method, limit: 10, comment: '请求方法'
      t.text :url, comment: '请求 URL'
      t.string :data_type, limit: 10, comment: 'data 参数类型 (form/json)'
      t.text :headers, comment: '请求 header'
      t.text :query_params, comment: 'url 参数'
      t.text :data, comment: 'body, get/delete 为空'

      # request builder
      t.text :other_params, comment: '其他自定义参数, 用于构建 query_params/data_type'
      t.string :request_digest, limit: 80, comment: '请求唯一 id'
      t.boolean :request_valid, comment: '请求是否符合规范, 若为 false, 不会发起请求'
      t.boolean :force, comment: '忽略缓存, 强制请求'

      # response
      t.integer :status_code, comment: 'response http code'
      t.text :response, comment: 'response body'
      t.text :response_headers, comment: 'response header'

      # response checker
      t.boolean :response_valid, comment: '请求结果 true/false, 这个要根据业务逻辑来设定. 不能靠 status_code 来确定'
      t.text :response_data, comment: '格式化后的 response'

      # relation
      t.string :client_type, limit: 80, comment: '请求类型'
      t.string :requestable_id, comment: '外键 ID'
      t.string :requestable_type, comment: '外键 类型'
      t.integer :parent_id

      t.index [:created_at, :client_type]
      t.index [:created_at, :response_valid]
      t.index :request_digest

      disabled_field(t)
    end
  end
end
