module Detail
  class SubtitleSerializer < ::SubtitleSerializer
    attribute :subtitle_lines do
      subtitle_lines = object.subtitle_lines
      subtitle_lines = subtitle_lines.ransack(text_cont: instance_options[:text_cont]).result if instance_options[:text_cont].present?

      subtitle_lines.map do |subtitle_line|
        record_by_serializer(subtitle_line, SubtitleLineSerializer)
      end
    end
  end
end
