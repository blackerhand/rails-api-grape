# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  code            :string(6)
#  disabled_at     :datetime
#  email           :string(100)
#  nickname        :string(100)
#  password_digest :string(255)
#  type            :string(40)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  created_user_id :bigint
#  grade_id        :bigint
#  updated_user_id :bigint
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_nickname  (nickname)
#  index_users_on_type      (type)
#
class User < ApplicationRecord
  include Disable
  rolify strict: true
  has_secure_password

  has_one :files_avatar, class_name: 'Files::Avatar', as: :fileable, dependent: :destroy
  validates :email, presence: true, uniqueness: true
  after_create :create_files_avatar!

  def self.ransackable_attributes(_auth_object = nil)
    %w[id nickname email type]
  end

  def add_resource_role(role_name, resource)
    add_role(role_name)
    add_role(role_name, resource)
  end

  def remove_resource_role(role_name, resource)
    remove_role(role_name)
    remove_role(role_name, resource) unless roles.resource_roles.exists?(name: role_name)
  end

  # 管理员
  def admin?
    type == 'Admin'
  end

  # 超级管理员
  def super_admin?
    has_role?(GRAPE_API::SUPER_ADMIN_ROLE_NAME)
  end

  # 超级管理员默认拥有所有权限，非超级管理员需要判断对于该资源是否有权限
  def resources?(resource_key)
    super_admin? || resource_keys.include?(resource_key)
  end

  def resources
    @resources ||=
      if super_admin?
        Resource.all
      else
        Resource.joins(:acls).where(acls: { role_id: roles.pure_roles.ids })
      end.order(id: :asc)
  end

  def resource_keys
    @resource_keys ||= resources.pluck(:key).uniq
  end

  def payload
    slice(:id, :type)
  end

  def avatar_url
    files_avatar.file_url
  end

  def self.build_with!(payload = {})
    payload = Hashie::Mash.new(payload) rescue Hashie::Mash.new
    user = find_by(id: payload.id)
    raise SignError, '用户不存在, 请重新登录' if user.nil?

    user
  end

  def gen_code!
    update!(code: rand(999_999).to_s.rjust(6, '0'))
    code
  end
end
