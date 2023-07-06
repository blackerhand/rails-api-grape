# 公用接口, 无需登录鉴权
module Api
  class PubGrape < BaseGrape
    helpers AuthHelper
    before { parse_current_user }

    get '/' do
      { status: 'ok' }
    end

    mount Api::V1::StaticGrape => '/v1'
    mount Api::PortalGrape
  end
end
