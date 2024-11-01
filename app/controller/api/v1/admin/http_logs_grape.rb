module Api::V1::Admin
  class HttpLogsGrape < Api::AdminGrape
    swagger_desc('get_http_logs')

    params do
      optional :q, type: Hash do
        string_field :client_type_eq, optional: true
      end
    end
    get '/' do
      @search    = HttpLog.ransack(params_q).result
      @http_logs = @search.order(id: :desc).page(params.page).per(page_per)
      data_paginate!(@http_logs, namespace: 'List')
    end
  end
end
