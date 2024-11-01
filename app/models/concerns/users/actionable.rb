module Users
  module Actionable
    extend ActiveSupport::Concern

    included do
      action_store :follow, :user, counter_cache: true # 关注

      def toggle_follow_user(user)
        if follow_user?(user)
          unfollow_user(user)
        else
          follow_user(user)
        end
      end
    end
  end
end
