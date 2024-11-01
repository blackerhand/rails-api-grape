module Api
  class UsersGrape < Api::SignGrape
    mount Api::V1::Users::AuthGrape => '/v1/users/auth'
    mount Api::V1::Users::DashboardGrape => '/v1/users'
  end
end
