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

ActiveRecord::Schema[7.0].define(version: 2024_02_27_062040) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "acls", force: :cascade do |t|
    t.bigint "resource_id"
    t.bigint "role_id"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "disabled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_user_id"], name: "index_acls_on_created_user_id"
    t.index ["disabled_at"], name: "index_acls_on_disabled_at"
    t.index ["role_id", "resource_id"], name: "index_acls_on_role_id_and_resource_id"
  end

  create_table "actions", force: :cascade do |t|
    t.string "action_type", limit: 64, null: false
    t.string "action_option", limit: 64
    t.string "target_type", limit: 64
    t.bigint "target_id"
    t.string "user_type", limit: 64
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_type", "target_type", "target_id", "user_type", "user_id"], name: "uk_action_target_user", unique: true
    t.index ["target_type", "target_id", "action_type"], name: "index_actions_on_target_type_and_target_id_and_action_type"
    t.index ["user_type", "user_id", "action_type"], name: "index_actions_on_user_type_and_user_id_and_action_type"
  end

  create_table "file_objects", force: :cascade do |t|
    t.string "type", limit: 40
    t.bigint "fileable_id"
    t.string "fileable_type", limit: 40
    t.string "file"
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
  end

  create_table "global_settings", force: :cascade do |t|
    t.string "key", comment: "键"
    t.text "value", comment: "值"
    t.string "desc", comment: "描述"
    t.bigint "user_id", comment: "用户ID"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "disabled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_user_id"], name: "index_global_settings_on_created_user_id"
    t.index ["disabled_at"], name: "index_global_settings_on_disabled_at"
    t.index ["key", "user_id"], name: "index_global_settings_on_key_and_user_id", unique: true
    t.index ["user_id"], name: "index_global_settings_on_user_id"
  end

  create_table "http_logs", force: :cascade do |t|
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
    t.integer "cache_response", comment: "是否缓存请求"
    t.integer "response_code", comment: "response code"
    t.integer "retry_times", comment: "重试次数"
    t.boolean "response_valid", comment: "请求结果 true/false, 这个要根据业务逻辑来设定. 不能靠 status_code 来确定"
    t.text "response_data", comment: "格式化后的 response"
    t.string "client_type", limit: 80, comment: "请求类型"
    t.string "requestable_id", comment: "外键 ID"
    t.string "requestable_type", comment: "外键 类型"
    t.integer "parent_id"
    t.boolean "is_system", default: false, comment: "是否系统请求"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "disabled_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["client_type"], name: "index_http_logs_on_client_type"
    t.index ["created_at", "client_type"], name: "index_http_logs_on_created_at_and_client_type"
    t.index ["created_at", "response_valid"], name: "index_http_logs_on_created_at_and_response_valid"
    t.index ["created_user_id"], name: "index_http_logs_on_created_user_id"
    t.index ["disabled_at"], name: "index_http_logs_on_disabled_at"
    t.index ["request_digest"], name: "index_http_logs_on_request_digest"
  end

  create_table "posts", force: :cascade do |t|
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

  create_table "resources", force: :cascade do |t|
    t.string "key", limit: 100, null: false, comment: "菜单名称"
    t.string "i18n_title", limit: 100, comment: "菜单中文名称"
    t.string "router_path", limit: 100, comment: "路由"
    t.boolean "keep_alive", default: false, null: false, comment: "页面保持"
    t.string "icon", limit: 100, comment: "图标"
    t.boolean "hide", default: true, null: false, comment: "是否隐藏"
    t.integer "order_index", default: 1, null: false, comment: "排序"
    t.integer "menu_type", default: 2, null: false, comment: "菜单类型"
    t.integer "platform", default: 1, null: false, comment: "平台"
    t.string "ancestry", limit: 100
    t.string "layout", limit: 100, comment: "布局"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "disabled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_resources_on_ancestry"
    t.index ["created_user_id"], name: "index_resources_on_created_user_id"
    t.index ["disabled_at"], name: "index_resources_on_disabled_at"
    t.index ["i18n_title"], name: "index_resources_on_i18n_title"
    t.index ["key"], name: "index_resources_on_key", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", limit: 100
    t.string "name_zh", limit: 100
    t.string "desc"
    t.bigint "resource_id"
    t.string "resource_type", limit: 40
    t.integer "base_role_id"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "disabled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["base_role_id"], name: "index_roles_on_base_role_id"
    t.index ["created_user_id"], name: "index_roles_on_created_user_id"
    t.index ["disabled_at"], name: "index_roles_on_disabled_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", unique: true
    t.index ["resource_id"], name: "index_roles_on_resource_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "user_type"
    t.string "email", limit: 100, comment: "邮箱"
    t.string "nickname", limit: 100, comment: "昵称"
    t.integer "gender", limit: 2, comment: "性别"
    t.string "code", limit: 6, comment: "验证码"
    t.string "password_digest"
    t.datetime "last_sign_in_at", comment: "最后登录时间"
    t.integer "follows_count", default: 0, comment: "关注数"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "disabled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_user_id"], name: "index_users_on_created_user_id"
    t.index ["disabled_at"], name: "index_users_on_disabled_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["nickname"], name: "index_users_on_nickname"
    t.index ["user_type"], name: "index_users_on_user_type"
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
