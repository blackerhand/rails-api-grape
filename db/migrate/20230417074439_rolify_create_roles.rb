require_relative '../disabled_field'

class RolifyCreateRoles < ActiveRecord::Migration[5.2]
  include DisabledField

  def change
    create_table(:roles) do |t|
      t.string :name, limit: 100
      t.string :name_zh, limit: 100
      t.string :desc
      t.bigint :resource_id, index: true
      t.string :resource_type, limit: GRAPE_API::TYPE_LIMIT_LENGTH

      disabled_field(t)
    end

    create_table(:users_roles, :id => false) do |t|
      t.references :user
      t.references :role
    end

    add_index(:roles, [:name, :resource_type, :resource_id], unique: true)
    add_index(:users_roles, [:user_id, :role_id])
  end
end
