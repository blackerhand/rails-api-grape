# base for sign grapes
module Api
  class SignGrape < BaseGrape
    helpers AuthHelper

    before { parse_jwt! }

    mount Api::V1::FileObjectsGrape => '/v1/files'
    mount Api::UsersGrape
    mount Api::AdminGrape
  end
end
