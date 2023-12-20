# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_12_20_025046) do
  create_table "acls", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "resource_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id", "resource_id"], name: "index_acls_on_role_id_and_resource_id"
  end

  create_table "file_objects", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "type", limit: 40
    t.bigint "fileable_id"
    t.string "fileable_type", limit: 40
    t.string "file"
    t.integer "user_id", comment: "上传人"
    t.string "ext", limit: 10, comment: "文件后缀"
    t.string "filename", comment: "文件名称"
    t.string "original_filename", comment: "原始文件名称"
    t.decimal "size", precision: 10, scale: 2, comment: "文件大小"
    t.string "content_digest", comment: "文件内容摘要"
    t.integer "order_index", default: 0, comment: "排序"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "disabled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_user_id"], name: "index_file_objects_on_created_user_id"
    t.index ["disabled_at"], name: "index_file_objects_on_disabled_at"
    t.index ["fileable_id", "fileable_type"], name: "index_file_objects_on_fileable_id_and_fileable_type"
    t.index ["user_id"], name: "index_file_objects_on_user_id"
  end

  create_table "http_logs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "http_method", limit: 10, comment: "请求方法"
    t.text "url", comment: "请求 URL"
    t.string "data_type", limit: 10, comment: "data 参数类型 (form/json)"
    t.text "headers", comment: "请求 header"
    t.text "query_params", comment: "url 参数"
    t.text "data", comment: "body, get/delete 为空"
    t.text "other_params", comment: "其他自定义参数, 用于构建 query_params/data_type"
    t.string "request_digest", limit: 80, comment: "请求唯一 id"
    t.boolean "request_valid", comment: "请求是否符合规范, 若为 false, 不会发起请求"
    t.boolean "force", comment: "忽略缓存, 强制请求"
    t.integer "status_code", comment: "response http code"
    t.text "response", comment: "response body"
    t.text "response_headers", comment: "response header"
    t.boolean "response_valid", comment: "请求结果 true/false, 这个要根据业务逻辑来设定. 不能靠 status_code 来确定"
    t.text "response_data", comment: "格式化后的 response"
    t.string "client_type", limit: 80, comment: "请求类型"
    t.string "requestable_id", comment: "外键 ID"
    t.string "requestable_type", comment: "外键 类型"
    t.integer "parent_id"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "disabled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "cache_response"
    t.integer "response_code"
    t.integer "retry_times"
    t.index ["client_type"], name: "index_http_logs_on_client_type"
    t.index ["created_at", "client_type"], name: "index_http_logs_on_created_at_and_client_type"
    t.index ["created_at", "response_valid"], name: "index_http_logs_on_created_at_and_response_valid"
    t.index ["created_user_id"], name: "index_http_logs_on_created_user_id"
    t.index ["disabled_at"], name: "index_http_logs_on_disabled_at"
    t.index ["request_digest"], name: "index_http_logs_on_request_digest"
  end

  create_table "posts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "title", null: false, comment: "标题"
    t.text "desc", comment: "说明"
    t.integer "click_number", default: 0, null: false, comment: "点击次数"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "disabled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["click_number"], name: "index_posts_on_click_number"
    t.index ["created_user_id"], name: "index_posts_on_created_user_id"
    t.index ["disabled_at"], name: "index_posts_on_disabled_at"
    t.index ["title"], name: "index_posts_on_title"
  end

  create_table "resources", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "key", limit: 100, null: false, comment: "菜单名称"
    t.string "i18n_title", limit: 100, comment: "菜单中文名称"
    t.string "router_path", limit: 100, comment: "路由"
    t.boolean "keep_alive", default: true, null: false, comment: "页面保持"
    t.string "icon", limit: 100, comment: "图标"
    t.boolean "hide", default: true, null: false, comment: "是否隐藏"
    t.integer "order_index", default: 1, null: false, comment: "排序"
    t.integer "menu_type", default: 2, null: false, comment: "菜单类型"
    t.integer "platform", default: 1, null: false, comment: "平台"
    t.string "ancestry", limit: 100
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "disabled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_resources_on_ancestry"
    t.index ["created_user_id"], name: "index_resources_on_created_user_id"
    t.index ["disabled_at"], name: "index_resources_on_disabled_at"
    t.index ["i18n_title"], name: "index_resources_on_i18n_title", unique: true
    t.index ["key"], name: "index_resources_on_key", unique: true
  end

  create_table "roles", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", limit: 100
    t.string "name_zh", limit: 100
    t.string "desc"
    t.bigint "resource_id"
    t.string "resource_type", limit: 40
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "disabled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_user_id"], name: "index_roles_on_created_user_id"
    t.index ["disabled_at"], name: "index_roles_on_disabled_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", unique: true
    t.index ["resource_id"], name: "index_roles_on_resource_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "type", limit: 40
    t.string "email", limit: 100, comment: "邮箱"
    t.string "nickname", limit: 100, comment: "昵称"
    t.integer "gender", limit: 1, comment: "性别"
    t.string "code", limit: 6, comment: "验证码"
    t.string "password_digest"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "disabled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_user_id"], name: "index_users_on_created_user_id"
    t.index ["disabled_at"], name: "index_users_on_disabled_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["nickname"], name: "index_users_on_nickname"
    t.index ["type"], name: "index_users_on_type"
  end

  create_table "users_roles", id: false, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "versions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.datetime "created_at"
    t.text "object_changes", size: :long
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
