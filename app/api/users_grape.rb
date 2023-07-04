class UsersGrape < SignGrape
  mount V1::Users::AuthGrape => '/v1/users/auth'
end
