module Entities
  module Role
    class List < Base
      expose_with_doc :id, :name, :name_zh, :desc, :can_modify

      expose :course, with: Entities::Course::Simple
    end
  end
end
