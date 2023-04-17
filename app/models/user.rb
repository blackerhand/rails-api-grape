class User < ApplicationRecord
  include Disable
  rolify

  has_one :files_avatar, class_name: 'Files::Avatar', as: :fileable

  after_create :create_files_avatar!

  def is_admin
    type == 'Admin'
  end

  def is_super_admin
    has_role?(GRAPE_API::SUPER_ADMIN_NAME)
  end

  # 超级管理员默认拥有所有权限，非超级管理员需要判断对于该资源是否有权限
  def has_resources?(resource_name)
    is_super_admin || resource_names.include?(resource_name)
  end

  def resource_names
    @resource_names ||=
      if is_super_admin
        Resource.all.order(id: :asc).map(&:name).uniq
      else
        Acl.where(role_id: roles.pure_roles.ids)
           .joins(:resource)
           .select("resources.name as resource_name")
           .order('resources.id asc')
           .map(&:resource_name).uniq
      end
  end

  def payload
    slice(:id, :is_admin)
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
end
