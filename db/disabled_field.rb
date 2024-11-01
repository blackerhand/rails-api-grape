module DisabledField
  def disabled_field(t)
    t.bigint :created_user_id, index: true
    t.bigint :updated_user_id
    t.datetime :disabled_at, index: true

    t.timestamps
  end

  def channel_field(t, unique = true)
    t.integer :channel, default: 0, comment: '来源'
    t.string :channel_id, index: true, comment: '来源 id'
    t.text :original_data, comment: '原始数据'
    t.datetime :synced_at, comment: '同步时间'

    if unique
      t.index [:channel, :channel_id], unique: true
    end
  end
end
