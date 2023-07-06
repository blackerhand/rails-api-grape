module Api
  class UsersGrape < Api::SignGrape
    mount Api::V1::Users::AuthGrape => '/v1/users/auth'
  end
end
