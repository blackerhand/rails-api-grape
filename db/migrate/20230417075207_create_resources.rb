require_relative '../disabled_field'

class CreateResources < ActiveRecord::Migration[5.2]
  include DisabledField

  def change
    create_table :resources do |t|
      t.string :key, limit: 100, comment: '菜单名称', null: false
      t.string :i18n_title, limit: 100, comment: '菜单中文名称'
      t.string :router_path, limit: 100, comment: '路由'
      t.boolean :keep_alive, default: true, null: false, comment: '页面保持'
      t.string :icon, limit: 100, comment: '图标'
      t.boolean :hide, default: true, null: false, comment: '是否隐藏'
      t.integer :order_index, default: 1, null: false, comment: '排序'
      t.integer :menu_type, default: 2, null: false, comment: '菜单类型'
      t.integer :platform, default: 1, null: false, comment: '平台'
      t.string :ancestry, limit: 100, index: true

      t.index :key, unique: true
      t.index :i18n_title, unique: true

      disabled_field(t)
    end
  end
end
