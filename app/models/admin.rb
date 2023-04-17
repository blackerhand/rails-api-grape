# == Schema Information
#
# Table name: users
#
#  id                                      :bigint           not null, primary key
#  can_access_totals(是否可以访问数据展板) :boolean
#  code                                    :string(6)
#  disabled_at                             :datetime
#  email                                   :string(100)
#  favorite_posts_count                    :integer          default(0)
#  like_posts_count                        :integer          default(0)
#  nickname                                :string(100)
#  password_digest                         :string(255)
#  sso_info                                :text(65535)
#  type                                    :string(40)
#  unlike_posts_count                      :integer          default(0)
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  created_user_id                         :bigint
#  sis_user_id(山大 id_number)             :string(255)
#  updated_user_id                         :bigint
#
# Indexes
#
#  index_users_on_nickname     (nickname)
#  index_users_on_sis_user_id  (sis_user_id)
#  index_users_on_type         (type)
#

class Admin < User
end
