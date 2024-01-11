# 管理员接口
module Api
  class AdminGrape < Api::SignGrape
    helpers AuthHelper

    before do
      parse_jwt!
      verify_admin!
      resource_authorize
    end

    # admin
    mount V1::Admin::DashboardGrape => '/v1/admin'
    mount V1::Admin::PostsGrape => '/v1/admin/posts'

    mount V1::Admin::UsersGrape => '/v1/admin/users'
    mount V1::Admin::RolesGrape => '/v1/admin/roles'
    mount V1::Admin::ResourcesGrape => '/v1/admin/resources'
    mount V1::Admin::HttpLogsGrape => '/v1/admin/http_logs'
    mount V1::Admin::GlobalSettingsGrape => '/v1/admin/global_settings'
  end
end
