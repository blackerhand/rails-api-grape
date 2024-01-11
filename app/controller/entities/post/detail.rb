module Entities
  module Post
    class Detail < Base
      expose_with_doc :title, :desc, :click_number
      expose :owner, using: Entities::User::Simple, documentation: { desc: '创建人信息' }
    end
  end
end
