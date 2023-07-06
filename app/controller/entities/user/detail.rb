module Entities
  module User
    class Detail < Base
      expose_with_doc :nickname,
                      :email,
                      :avatar_url,
                      :disabled_at,
                      :type

      expose_with_doc :roles, using: Entities::Role::List
    end
  end
end
