module HtmlField
  extend ActiveSupport::Concern

  def get_site_file(src, file_class)
    return if src.blank?

    file = file_class.query_by_url(src)
    return file if file.present?

    tempfile = Uploads::RemoteImgService.execute(src)
    file_class.create!(file: tempfile)
  rescue Uploads::RemoteImgGetError
    nil
  end

  module ClassMethods
    def html_field(field, file_class, video_class)
      file_association  = file_class.to_s.underscore.tr('/', '_').to_sym
      file_associations = file_association.to_s.pluralize.to_sym

      video_association  = video_class.to_s.underscore.tr('/', '_').to_sym
      video_associations = video_association.to_s.pluralize.to_sym

      html_fragment field, scrub: :prune
      has_many file_associations, class_name: file_class.to_s, as: :fileable, dependent: :destroy
      has_one file_association, class_name: file_class.to_s, as: :fileable, dependent: :destroy

      has_many video_associations, class_name: video_class.to_s, as: :fileable, dependent: :destroy
      has_one video_association, class_name: video_class.to_s, as: :fileable, dependent: :destroy

      around_save do |_activity, block|
        field_content = send(field)
        doc           = Loofah.fragment(field_content)

        # 获取 html 中的所有图片
        files = doc.search('img').map do |img|
          file = get_site_file(img.attributes['src'].try(:value), file_class)
          next img.remove && nil if file.nil?

          img.attributes['src'].value = file.full_url
          file
        end.compact

        videos = doc.search('video').map do |video|
          file = get_site_file(video.attributes['src'].try(:value), video_class)
          file.nil? ? video.remove && nil : file
        end.compact

        send("#{field}=", doc.to_s)

        block.call

        # 保存后删除没有关联的文件
        send(file_associations).where.not(id: files.map(&:id)).destroy_all
        send(video_associations).where.not(id: videos.map(&:id)).destroy_all

        send("#{file_associations}=", files)
        send("#{file_association}=", files.first || send("create_#{file_association}!"))

        send("#{video_associations}=", videos)
        send("#{video_association}=", videos.first || send("create_#{video_association}!"))
      end
    end
  end
end
