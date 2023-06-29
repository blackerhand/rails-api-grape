# 管理员接口
class AdminGrape < SignGrape
  helpers AuthHelper

  before do
    parse_jwt!
    verify_admin!
    resource_authorize
  end

  mount V1::Admin::DashboardGrape => '/v1/admin'
  mount V1::Admin::UsersGrape => '/v1/admin/users'
  mount V1::Admin::RolesGrape => '/v1/admin/roles'
  mount V1::Admin::ResourcesGrape => '/v1/admin/resources'
end
