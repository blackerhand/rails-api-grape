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
