# == Schema Information
#
# Table name: acls
#
#  id              :bigint           not null, primary key
#  disabled_at     :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  created_user_id :bigint
#  resource_id     :bigint
#  role_id         :bigint
#  updated_user_id :bigint
#
# Indexes
#
#  index_acls_on_created_user_id          (created_user_id)
#  index_acls_on_disabled_at              (disabled_at)
#  index_acls_on_role_id_and_resource_id  (role_id,resource_id)
#
class Acl < ApplicationRecord
  belongs_to :role
  belongs_to :resource
end
