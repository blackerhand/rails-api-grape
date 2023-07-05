# == Route Map
#

Rails.application.routes.draw do
  # pub ===
  mount BaseGrape => '/'
  mount V1::StaticGrape => '/v1'
  mount V1::Portal::DashboardGrape => '/v1/portal'
  mount V1::Portal::PostsGrape => '/v1/portal/posts'

  # sign ===
  mount V1::FileObjectsGrape => '/v1/files'

  # admin
  mount V1::Admin::DashboardGrape => '/v1/admin'
  mount V1::Admin::UsersGrape => '/v1/admin/users'
  mount V1::Admin::RolesGrape => '/v1/admin/roles'
  mount V1::Admin::ResourcesGrape => '/v1/admin/resources'

  # users
  mount V1::Users::AuthGrape => '/v1/users/auth'

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  Sidekiq::Web.use ActionDispatch::Cookies
  Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

  unless Rails.env.development?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      username == 'xxx' && password == 'xxx'
    end
  end

  mount Sidekiq::Web => '/sidekiq'
  mount GrapeSwaggerRails::Engine => '/swagger'
end
