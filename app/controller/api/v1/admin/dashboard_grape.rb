module Api::V1::Admin
  class DashboardGrape < Api::AdminGrape
    desc '左边栏列表' do
      summary '左边栏列表'
      detail '左边栏列表'
      tags ['admin_dashboard']
      success Entities::Resource::Detail
    end
    get '/menus' do
      @menus = current_user.resources.admin_menus.arrange
      data! ancestry_tree(@menus, Entities::Resource::Detail)
    end

    desc '验重接口' do
      summary '验重接口'
      detail '验重接口'
      tags ['admin_dashboard']
      success Entities::Resource::Detail
    end
    params do
      string_field :model_field, type: String, desc: '字段关键字, 例如 resource.name'
      string_field :field_value, type: String
    end
    get '/check' do
      model_class, enum_key = tran_model_field(params.model_field)
      valid_error!('字段不存在, 请检查') if enum_key.blank?

      data!(exists: model_class.exists?(enum_key => params.field_value))
    end
  end
end
