# 管理员接口
class AdminGrape < SignGrape
  helpers AuthHelper

  before do
    parse_jwt!
    verify_admin!
    resource_authorize
  end
end
