class AdminGrape < SignGrape
  helpers AuthHelper
  helpers Pundit

  before do
    parse_jwt!
    verify_admin!
    resource_authorize
    pundit_authorize
  end

  mount V1::Admin::UsersGrape => '/v1/admin/users'
  mount V1::Admin::RolesGrape => '/v1/admin/roles'
  mount V1::Admin::ResourcesGrape => '/v1/admin/resources'
end
