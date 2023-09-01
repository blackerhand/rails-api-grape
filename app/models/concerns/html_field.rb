module HtmlField
  extend ActiveSupport::Concern

  module ClassMethods
    def html_field(field, file_class)
      file_association  = file_class.to_s.underscore.tr('/', '_').to_sym
      file_associations = file_association.to_s.pluralize.to_sym

      html_fragment field, scrub: :prune
      has_many file_associations, class_name: file_class.to_s, as: :fileable, dependent: :destroy
      has_one file_association, class_name: file_class.to_s, as: :fileable, dependent: :destroy

      around_save do |_activity, block|
        field_content = send(field)
        doc           = Loofah.fragment(field_content)

        # 获取 html 中的所有图片
        files = doc.search('img').map do |img|
          file = file_class.query_by_url(img.attributes['src'].try(:value))
          next file if file.present?

          # 删除后返回 nil
          img.remove && nil
        end.compact

        send("#{field}=", doc.to_s)

        block.call

        # 保存后删除没有关联的文件
        send(file_associations).where.not(id: files.map(&:id)).destroy_all

        send("#{file_associations}=", files)
        send("#{file_association}=", files.first || send("create_#{file_association}!"))
      end
    end
  end
end
