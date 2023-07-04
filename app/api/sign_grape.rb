# base for sign grapes
class SignGrape < BaseGrape
  helpers AuthHelper

  before { parse_jwt! }

  # mounts
  mount V1::FileObjectsGrape => '/v1/files'

  mount UsersGrape
  mount AdminGrape
end
