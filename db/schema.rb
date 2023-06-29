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

ActiveRecord::Schema[7.0].define(version: 2023_05_09_090433) do
  create_table "acls", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "resource_id"
    t.bigint "role_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "file_objects", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "type", limit: 40
    t.bigint "fileable_id"
    t.string "fileable_type", limit: 40
    t.string "file"
    t.integer "user_id"
    t.string "ext"
    t.string "filename"
    t.string "original_filename"
    t.decimal "size", precision: 10
    t.string "content_digest"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "disabled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "title", null: false, comment: "标题"
    t.text "desc", comment: "说明"
    t.integer "click_number", default: 0, comment: "点击次数"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "disabled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["click_number"], name: "index_posts_on_click_number"
  end

  create_table "resources", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "key", limit: 100, null: false, comment: "菜单名称"
    t.string "i18n_title", limit: 100, comment: "菜单中文名称"
    t.string "router_path", limit: 100, comment: "路由"
    t.boolean "keep_alive", default: true, comment: "页面保持"
    t.string "icon", limit: 100, comment: "图标"
    t.boolean "hide", default: true, comment: "是否隐藏"
    t.integer "order_index", default: 1, comment: "排序"
    t.integer "menu_type", default: 2, comment: "菜单类型"
    t.integer "platform", default: 1, comment: "平台"
    t.string "ancestry", limit: 100
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "disabled_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ancestry"], name: "index_resources_on_ancestry"
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
    t.datetime "disabled_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "email", limit: 100
    t.string "nickname", limit: 100
    t.string "type", limit: 40
    t.string "code", limit: 6
    t.string "password_digest"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "disabled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
