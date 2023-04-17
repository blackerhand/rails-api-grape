class Role < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_roles

  belongs_to :resource,
             :polymorphic => true,
             :optional    => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify

  scope :pure_roles, -> { where(resource_id: nil) }
  validates :name, uniqueness: true

  def can_modify
    GRAPE_API::SUPER_ADMIN_NAME != name.to_s.to_sym
  end
end
