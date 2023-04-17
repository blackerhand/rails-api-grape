module Entities
  module Post
    class List < Base
      expose_with_doc :title, :click_number
    end
  end
end
