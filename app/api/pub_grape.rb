# 公用接口, 无需登录鉴权
class PubGrape < BaseGrape
  helpers AuthHelper
  before { parse_current_user }
end
