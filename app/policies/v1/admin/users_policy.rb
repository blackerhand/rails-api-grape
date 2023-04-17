module V1
  module Admin
    class UsersPolicy < ApplicationPolicy
      def get_index?
        login_required!
      end
    end
  end
end
