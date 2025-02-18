module DisabledField
  def disabled_field(t)
    t.bigint :created_user_id, index: true
    t.bigint :updated_user_id
    t.datetime :disabled_at, index: true

    t.timestamps
  end

  def channel_field(t, unique = true)
    t.integer :channel, index: true, default: 0, comment: '来源'
    t.string :channel_id, index: true, comment: '来源 id'
    hash_field(t, :original_data)
    t.datetime :synced_at, comment: '同步时间'
    t.bigint :platform_id, index: true, comment: '平台 id'

    if unique
      t.index [:channel, :channel_id], unique: true
    end
  end

  def multi_channel_field(t)
    t.jsonb :channel_source, default: {}, comment: '来源数据'
    t.index :channel_source, using: :gin
  end

  def belongs_to_course(t)
    t.bigint :course_id, index: true
    t.bigint :college_id, index: true
    t.bigint :term_id, index: true
  end

  def stat_columns(t)
    t.string :type, limit: GRAPE_API::TYPE_LIMIT_LENGTH, comment: '统计类型'

    t.date :stat_date, index: true, comment: '统计日期'
    t.jsonb :stat_data, default: {}, comment: '统计数据'
    t.index :stat_data, using: :gin
  end

  def hash_field(t, field_name)
    t.jsonb field_name, default: {}
  end
end
