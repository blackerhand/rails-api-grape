# base for sign grapes
module Api
  class SignGrape < BaseGrape
    helpers AuthHelper
    helpers FootmarkHelper

    before do
      parse_jwt!
      set_locale
    end

    mount Api::V1::FileObjectsGrape => '/v1/files'
    mount Api::UsersGrape
    mount Api::AdminGrape
  end
end
