module Entities
  module Role
    class Detail < Base
      expose_with_doc :id, :name, :name_zh, :desc, :resource_ids, :can_modify
    end
  end
end
