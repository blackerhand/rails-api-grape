class PubGrape < BaseGrape
  # helpers AuthHelper
  # before { parse_current_user }

  # mounts
  mount V1::StaticGrape => '/v1'
  # mount V1::CoursesGrape => '/v1/courses'
  # mount V1::GuidesGrape => '/v1/guides'
  # mount V1::PostsGrape => '/v1/posts'
  # mount V1::TermsGrape => '/v1/terms'
end
