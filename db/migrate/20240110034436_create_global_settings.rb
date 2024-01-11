class CreateGlobalSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :global_settings do |t|
      t.string :key, comment: '键'
      t.string :value, comment: '值'
      t.string :desc, comment: '描述'
      t.bigint :user_id, index: true, comment: '用户ID'

      t.index [:key, :user_id], unique: true
      disabled_field(t)
    end
  end
end
