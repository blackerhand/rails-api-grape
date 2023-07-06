# 门户
module Api
  class PortalGrape < Api::PubGrape
    mount Api::V1::Portal::DashboardGrape => '/v1/portal'
    mount Api::V1::Portal::PostsGrape => '/v1/portal/posts'
  end
end
