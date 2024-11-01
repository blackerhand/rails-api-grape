# == Schema Information
#
# Table name: resources
#
#  id                       :bigint           not null, primary key
#  ancestry                 :string(100)
#  disabled_at              :datetime
#  hide(是否隐藏)           :boolean          default(TRUE), not null
#  i18n_title(菜单中文名称) :string(100)
#  icon(图标)               :string(100)
#  keep_alive(页面保持)     :boolean          default(FALSE), not null
#  key(菜单名称)            :string(100)      not null
#  layout(布局)             :string(100)
#  menu_type(菜单类型)      :integer          default("button"), not null
#  order_index(排序)        :integer          default(1), not null
#  platform(平台)           :integer          default("admin"), not null
#  router_path(路由)        :string(100)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  created_user_id          :bigint
#  updated_user_id          :bigint
#
# Indexes
#
#  index_resources_on_ancestry         (ancestry)
#  index_resources_on_created_user_id  (created_user_id)
#  index_resources_on_disabled_at      (disabled_at)
#  index_resources_on_i18n_title       (i18n_title)
#  index_resources_on_key              (key) UNIQUE
#
class Resource < ApplicationRecord
  has_ancestry

  scope :all_menus, -> { where(menu_type: 'menu').order(order_index: :asc) }
  scope :valid_parents, -> { where(menu_type: ['menu', 'root']).order(order_index: :asc) }
  scope :all_resources, -> { order(order_index: :asc) }
  scope :admin_menus, -> { all_menus.platform_admin }
  scope :teacher_menus, -> { all_menus.platform_teacher }
  scope :student_menus, -> { all_menus.platform_student }

  has_many :acls, dependent: :destroy
  has_many :roles, through: :acls

  validates :key, presence: true, uniqueness: true
  # validates :i18n_title, presence: true, uniqueness: true

  pre_enum menu_type: { menu: 1, button: 2, root: 3 }, _prefix: true
  pre_enum platform: { admin: 1, teacher: 2, student: 3 }, _prefix: true
end
