# == Schema Information
#
# Table name: roles
#
#  id              :bigint           not null, primary key
#  desc            :string(255)
#  disabled_at     :datetime
#  name            :string(100)
#  name_zh         :string(100)
#  resource_type   :string(40)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  created_user_id :bigint
#  resource_id     :bigint
#  updated_user_id :bigint
#
# Indexes
#
#  index_roles_on_created_user_id                         (created_user_id)
#  index_roles_on_disabled_at                             (disabled_at)
#  index_roles_on_name_and_resource_type_and_resource_id  (name,resource_type,resource_id) UNIQUE
#  index_roles_on_resource_id                             (resource_id)
#
class Role < ApplicationRecord
  include Disable
  scopify

  scope :pure_roles, -> { enabled.where(resource_id: nil) }
  scope :resource_roles, -> { enabled.where.not(resource_id: nil) }

  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :resources, join_table: :acls
  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true, optional: true
  # rubocop:enable Rails/HasAndBelongsToMany

  validates :resource_type, inclusion: { in: Rolify.resource_types }, allow_nil: true
  validates :name, uniqueness: { scope: :resource_id }

  before_create :set_default_name_zh

  def can_modify
    name.to_s.to_sym != GRAPE_API::SUPER_ADMIN_ROLE_NAME
  end

  # 获取单个关联对象角色的通用角色 (pure_roles)
  # 在通用角色上设置用户的权限
  def base_role
    return self if resource_id.nil?

    self.class.find_or_create_by!(name: name, resource: nil, name_zh: default_name_zh)
  end

  private

  def default_name_zh
    case name.to_sym
    when GRAPE_API::SUPER_ADMIN_ROLE_NAME
      '管理员'
    else
      name
    end
  end

  def set_default_name_zh
    self.name_zh = default_name_zh if name_zh.blank?
  end
end
