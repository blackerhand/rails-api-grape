class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :user_type, index: true

      t.string :email, limit: 100, comment: '邮箱'
      t.string :nickname, limit: 100, index: true, comment: '昵称'
      t.integer :gender, limit: 1, comment: '性别'
      t.string :code, limit: 6, comment: '验证码'
      t.string :password_digest
      t.datetime :last_sign_in_at, comment: '最后登录时间'
      t.integer :follows_count, default: 0, comment: '关注数'

      t.index :email, unique: true

      disabled_field(t)
    end
  end
end
