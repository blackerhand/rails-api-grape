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
#  updated_user_id :bigint
#
# Indexes
#
#  index_users_on_nickname  (nickname)
#  index_users_on_type      (type)
#

class Admin < User
end
