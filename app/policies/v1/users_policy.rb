module V1
  class UsersPolicy < ApplicationPolicy
    def post_users_sign_in?
      true
    end

    def post_users_sign_up?
      true
    end

    def put_users_avatar?
      login_required!
    end
  end
end
