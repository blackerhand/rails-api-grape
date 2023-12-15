module DisabledField
  def disabled_field(t)
    t.bigint :created_user_id, index: true
    t.bigint :updated_user_id
    t.datetime :disabled_at, index: true

    t.timestamps
  end

  def string_100_field(t, name, comment, index: false)
    t.string name, limit: 100, index: index, comment: comment
  end

  def string_40_field(t, name, index: false)
    t.string name, limit: 40, index: index, comment: comment
  end
end
