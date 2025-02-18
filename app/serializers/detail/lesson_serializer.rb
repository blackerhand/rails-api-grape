module Detail
  class LessonSerializer < List::LessonSerializer
    attributes :can_talk

    lazy_belongs_to :course
    lazy_has_one :lesson_graph
    lazy_has_one :subtitle, serializer: ::SubtitleSerializer

    attribute :xunke_dir do
      record_by_serializer(object.xunke_dir, Tree::CourseDirSerializer)
    end

    attribute :is_liked do
      instance_options[:current_user].try(:like_lesson?, object)
    end

    attribute :like_at do
      Action.where(user_id: instance_options[:current_user]&.id, target: object, action_type: 'like').first.try(:created_at)&.strftime('%F %T')
    end

    attribute :my_note do
      note = object.notes.find_by(owner: instance_options[:current_user])
      record_by_serializer(note, Detail::NoteSerializer)
    end

    attributes :task_chat_lesson_desc_last
    attributes :task_chat_lesson_keywords_last
    attributes :task_chat_lesson_questions_last
  end
end
