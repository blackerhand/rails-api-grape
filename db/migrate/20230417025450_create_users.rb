class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, limit: 100
      t.string :nickname, limit: 100, index: true
      t.string :type, index: true, limit: GRAPE_API::TYPE_LIMIT_LENGTH
      t.string :code, limit: 6
      t.string :password_digest

      t.bigint :created_user_id
      t.bigint :updated_user_id
      t.datetime :disabled_at

      t.index :email, unique: true

      t.timestamps
    end
  end
end
