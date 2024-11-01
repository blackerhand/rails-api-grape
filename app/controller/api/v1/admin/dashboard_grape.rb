module Api::V1::Admin
  class DashboardGrape < Api::AdminGrape
    swagger_desc('get_admin_menus')
    get '/menus' do
      @menus = current_user.resources.admin_menus.arrange
      data! ancestry_tree(@menus, namespace: 'List')
    end

    swagger_desc('get_admin_check')
    params do
      string_field :model_field, type: String, desc: '字段关键字, 例如 resource.name'
      string_field :field_value, type: String
    end
    get '/check' do
      model_class, enum_key = tran_model_field(params.model_field)
      valid_error!('field_not_exists') if enum_key.blank?

      data!(exists: model_class.exists?(enum_key => params.field_value))
    end
  end
end
