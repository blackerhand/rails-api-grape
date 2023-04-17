class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources do |t|
      t.string :name, limit: 100, unique: true, null: false
      t.string :description
      t.integer :status
      t.string :ancestry, limit: 100, index: true

      t.bigint :created_user_id
      t.bigint :updated_user_id
      t.datetime :disabled_at

      t.timestamps
    end
  end
end
