module Detail
  class CoursewareSerializer < List::CoursewareSerializer
    attributes :original_data, :content, :can_talk

    lazy_has_many :comments
    lazy_belongs_to :device
    lazy_has_one :files_courseware, serializer: FileObjectSerializer

    attribute :submissions do
      object.submissions.map do |submission|
        record_by_serializer(submission, ::SubmissionSerializer)
      end
    end

    attribute :ai_task do
      record_by_serializer(object.ai_task, ::AiTaskSerializer) if object.ai_task
    end

    attribute :is_stared do
      instance_options[:current_user].try(:star_courseware?, object)
    end

    attribute :star_at do
      Action.where(user_id: instance_options[:current_user]&.id, target: object, action_type: 'star').first.try(:created_at)
    end
  end
end
