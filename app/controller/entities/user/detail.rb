module Entities
  module User
    class Detail < Base
      include Entities::User::Meta

      expose_with_doc :roles, using: Entities::Role::List
    end
  end
end
