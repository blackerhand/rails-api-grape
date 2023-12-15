# == Schema Information
#
# Table name: acls
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  resource_id :bigint
#  role_id     :bigint
#
# Indexes
#
#  index_acls_on_role_id_and_resource_id  (role_id,resource_id)
#
class Acl < ApplicationRecord
  belongs_to :role
  belongs_to :resource
end
