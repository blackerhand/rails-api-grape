class CreateAcls < ActiveRecord::Migration[5.2]
  def change
    create_table :acls do |t|
      t.bigint :resource_id
      t.bigint :role_id

      t.timestamps
    end
  end
end
