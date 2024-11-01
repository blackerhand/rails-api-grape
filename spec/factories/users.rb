# == Schema Information
#
# Table name: users
#
#  id                            :bigint           not null, primary key
#  code(验证码)                  :string(6)
#  disabled_at                   :datetime
#  email(邮箱)                   :string(100)
#  follows_count(关注数)         :integer          default(0)
#  gender(性别)                  :integer
#  last_sign_in_at(最后登录时间) :datetime
#  nickname(昵称)                :string(100)
#  password_digest               :string
#  user_type                     :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  created_user_id               :bigint
#  updated_user_id               :bigint
#
# Indexes
#
#  index_users_on_created_user_id  (created_user_id)
#  index_users_on_disabled_at      (disabled_at)
#  index_users_on_email            (email) UNIQUE
#  index_users_on_nickname         (nickname)
#  index_users_on_user_type        (user_type)
#
FactoryBot.define do
  factory :user do
    nickname { "John Doe" }
    password { "password" }
    email { Faker::Internet.email }

    factory :admin do
      type { "Admin" }

      factory :super_admin do
        after(:create) do |user|
          user.add_role(GRAPE_API::SUPER_ADMIN_ROLE_NAME)
        end
      end
    end
  end
end
