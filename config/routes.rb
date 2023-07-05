# == Route Map
#

Rails.application.routes.draw do
  # pub ===
  mount RoutesGrape => '/'

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
