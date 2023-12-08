module Entities
  module User
    module Meta
      extend ActiveSupport::Concern

      included do
        expose_with_doc :nickname,
                        :email,
                        :avatar_url,
                        :disabled_at,
                        :type,
                        :gender,
                        :gender_name,
                        :school_id,
                        :can_login,
                        :mask_phone

        expose :rider?, as: :is_rider
      end
    end
  end
end
