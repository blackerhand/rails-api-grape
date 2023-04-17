Rails.application.routes.draw do
  mount BaseGrape => '/'

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  Sidekiq::Web.use ActionDispatch::Cookies
  Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

  unless Rails.env.development?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      username == 'admin' && password == '7846e1b0119b18893j41151b280ecdf7'
    end
  end

  mount Sidekiq::Web => '/sidekiq'
  mount GrapeSwaggerRails::Engine => '/swagger'
end
