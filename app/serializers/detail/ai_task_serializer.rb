module Detail
  class AiTaskSerializer < List::AiTaskSerializer
    lazy_has_many :normal_questions, key: :ai_questions
    lazy_has_one :ai_medium, serializer: Detail::AiMediumSerializer
    lazy_has_many :field_processes

    lazy_belongs_to :owner
    lazy_belongs_to :course
    lazy_belongs_to :lesson
    lazy_belongs_to :courseware
  end
end
