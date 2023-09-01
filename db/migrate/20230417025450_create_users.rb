class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :type, index: true, limit: GRAPE_API::TYPE_LIMIT_LENGTH

      t.string :email, limit: 100, comment: '邮箱'
      t.string :nickname, limit: 100, index: true, comment: '昵称'
      t.string :code, limit: 6, comment: '验证码'
      t.string :password_digest

      t.bigint :created_user_id
      t.bigint :updated_user_id
      t.datetime :disabled_at, index: true

      t.index :email, unique: true

      t.timestamps
    end
  end
end
