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
class Acl < ApplicationRecord
  belongs_to :role
  belongs_to :resource
end
