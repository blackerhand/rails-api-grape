module Entities
  module User
    class Detail < Base
      expose_with_doc :nickname,
                      :email,
                      :avatar_url,
                      :disabled_at,
                      :is_admin

      expose :roles, using: Entities::Role::List, documentation: { desc: '角色' }
    end
  end
end
