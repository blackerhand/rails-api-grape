module Api::V1::Admin
  class GlobalSettingsGrape < Api::AdminGrape
    helpers do
      def current_scope
        GlobalSetting.global_settings
      end
    end

    swagger_desc 'get_admin_global_settings'
    params do
      optional :q, type: Hash do
        string_field :key_cont, type: String, optional: true
      end
    end
    get '/' do
      @search          = current_scope.ransack(params[:q])
      @global_settings = @search.result.order(id: :desc)
                                .page(params_page).per(page_per)

      data_paginate!(@global_settings, namespace: 'List')
    end

    route_param :id, requirements: { id: /[0-9]+/ } do
      base.swagger_desc('put_admin_global_settings_id')
      params do
        requires :global_setting, type: Hash do
          string_field :desc, type: String, optional: true
          text_field :value, type: String, optional: true
          array_field :files_setting_file_ids, type: Array, optional: true
        end
      end
      put '/' do
        current_record.update!(declared_params)
        data_record!(current_record, namespace: 'List')
      end
    end
  end
end
