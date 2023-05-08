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
#  index_roles_on_name                                    (name) UNIQUE
#  index_roles_on_name_and_resource_type_and_resource_id  (name,resource_type,resource_id)
#
class Role < ApplicationRecord
  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :users, join_table: :users_roles
  # rubocop:enable Rails/HasAndBelongsToMany

  belongs_to :resource,
             polymorphic: true,
             optional:    true

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  scopify

  scope :pure_roles, -> { where(resource_id: nil) }
  validates :name, uniqueness: true

  def can_modify
    name.to_s.to_sym != GRAPE_API::SUPER_ADMIN_NAME
  end
end
