module Entities
  module User
    class Info < Base
      expose_with_doc :nickname, :email, :avatar_url,
                      :disabled_at,
                      :admin?
    end
  end
end
