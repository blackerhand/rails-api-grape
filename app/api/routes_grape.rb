class RoutesGrape < Grape::API
  get '/' do
    { status: 'ok' }
  end

  # pub ===
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

  add_swagger_documentation(
    mount_path:  '/api/swagger',
    doc_version: '0.1.0',
    host:        Settings.HOST.gsub(/(http|https):\/\//, ''),
    tags:        [
                   { name: 'static', description: '通用接口' },
                   { name: 'files', description: '文件' },
                   { name: 'users_auth', description: '用户登录' },
                   { name: 'posts', description: '新闻' },

                   # portal
                   { name: 'portal_dashboard', description: '首页' },
                   { name: 'portal_posts', description: '新闻' },

                   # admin
                   { name: 'admin_dashboard', description: 'ADMIN 通用接口, 无需鉴权' },
                   { name: 'admin_resources', description: '权限管理' },
                   { name: 'admin_roles', description: '角色管理' },
                   { name: 'admin_posts', description: '新闻管理' },
                 ]
  )
end
