# 门户
class PortalGrape < PubGrape
  mount V1::Portal::DashboardGrape => '/v1/portal'
  mount V1::Portal::PostsGrape => '/v1/portal/posts'
end
