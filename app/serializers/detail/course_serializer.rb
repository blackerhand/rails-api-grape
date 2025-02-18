module Detail
  class CourseSerializer < List::CourseSerializer
    attribute :assistants do
      object.assistants.map do |assistant|
        UserSerializer.new(assistant).serializable_hash
      end
    end
  end
end
