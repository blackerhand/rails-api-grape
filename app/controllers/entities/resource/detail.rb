module Entities
  module Resource
    class Detail < Base
      expose_with_doc :id, :description, :name
    end
  end
end
