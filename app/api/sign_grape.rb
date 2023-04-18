# base for sign grapes
class SignGrape < BaseGrape
  helpers AuthHelper
  # helpers Pundit

  before { parse_jwt! }

  # mounts
  mount V1::UsersGrape => '/v1/users'
  # mount V1::FileObjectsGrape => '/v1/files'
end
