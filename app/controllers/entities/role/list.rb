module Entities
  module Role
    class List < Base
      expose_with_doc :id, :name, :name_zh, :desc, :can_modify
    end
  end
end
