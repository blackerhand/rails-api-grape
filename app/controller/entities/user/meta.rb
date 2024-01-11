module Entities
  module User
    module Meta
      extend ActiveSupport::Concern

      included do
        expose_with_doc :nickname,
                        :email,
                        :avatar_url,
                        :disabled_at,
                        :disabled_desc,
                        :type
      end
    end
  end
end
