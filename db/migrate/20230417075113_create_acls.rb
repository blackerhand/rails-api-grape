class CreateAcls < ActiveRecord::Migration[7.0]
  def change
    create_table :acls do |t|
      t.bigint :resource_id
      t.bigint :role_id

      disabled_field(t)

      t.index [:role_id, :resource_id]
    end
  end
end
