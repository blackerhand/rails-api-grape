class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false, comment: '标题'
      t.text :desc, comment: '说明'
      t.integer :click_number, default: 0, index: true, comment: '点击次数'

      t.bigint :created_user_id
      t.bigint :updated_user_id
      t.datetime :disabled_at

      t.timestamps
    end
  end
end
