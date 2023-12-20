class CreateFileObjects < ActiveRecord::Migration[7.0]
  def change
    create_table :file_objects do |t|
      t.string :type, limit: GRAPE_API::TYPE_LIMIT_LENGTH

      t.bigint :fileable_id
      t.string :fileable_type, limit: GRAPE_API::TYPE_LIMIT_LENGTH

      t.string :file
      t.integer :user_id, index: true, comment: '上传人'
      t.string :ext, limit: 10, comment: '文件后缀'
      t.string :filename, comment: '文件名称'
      t.string :original_filename, comment: '原始文件名称'
      t.decimal :size, precision: 10, scale: 2, comment: '文件大小'
      t.string :content_digest, comment: '文件内容摘要'
      t.integer :order_index, default: 0, comment: '排序'
      t.index [:fileable_id, :fileable_type]

      disabled_field(t)
    end
  end
end
