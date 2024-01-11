# 200 code 返回 data 构建规则
# 203 表示 token 有更新, 检查 response header Authorization, 得到新的token, 此时应该更新客户端的 token
# 结构说明 {meta: {*payload, path: '/', version: '1'}, data: {id: '1', type: 'User', attributes: {}}/[]}
module DataBuildHelper
  # render service 返回, [true, {data}]
  def render_service!(rsp, opts = {})
    status, result, service_opts = rsp
    opts                         = opts.merge(service_opts) if service_opts.present?

    status ? data!(result, opts) : error_422!(result, opts)
  end

  # 返回文件
  def data_file_object!(file_object, opts = {})
    file_name = opts.delete(:file_name) || file_object.filename_with_ext

    content_type 'application/octet-stream'
    header['Access-Control-Expose-Headers'] = 'Content-Disposition'
    header['Content-Disposition']           = "attachment; filename=#{ERB::Util.url_encode(file_name)}"
    env['api.format']                       = :binary

    File.read(file_object.real_file_path)
  end

  def data_message!(message)
    data!(I18n.t_message(message))
  end

  def data!(data, opts = {})
    meta = default_meta

    if data.is_a?(String)
      meta[:message] = data
      data           = nil
    elsif data.is_a?(Hash) && data[:meta].present?
      meta.merge!(data.delete(:meta))
    end

    { meta: meta.merge(opts), data: data }
  end

  def data_client!(client)
    error_422!(client.response_data) unless client.response_valid?
    data!(client.response_data)
  end

  def data_image_client!(client, opts = {})
    error_422!(client.response_data) unless client.response_valid?

    file_name   = opts.delete(:file_name) || 'qr'
    opt_headers = opts.delete(:headers) || {}

    opt_headers.each { |k, v| header[k.to_s] = v }

    content_type 'image/jpeg'
    env['api.format'] = :binary
    # content_type 'application/octet-stream'
    header['Content-Disposition']           = "attachment; filename=#{file_name}.jpg"
    header['Access-Control-Expose-Headers'] = opt_headers.keys.push('Content-Disposition').join(',')

    client.response
  end

  def base_num(records)
    return 0 if records.try(:current_page).nil?

    (records.current_page - 1) * records.limit_value
  end

  def default_opts
    {
      current_user_id: current_user_id,
      current_user:    current_user,
    }
  end

  def data_paginate!(records, entities_class, meta = {})
    opts = meta.delete(:opts) || {}
    opts.merge!(default_opts)

    {
      meta: default_meta.merge(pagination(records)).merge(meta),
      data: json_records!(records, entities_class, opts)
    }
  end

  def format_file_values(filed_values)
    filed_values.map do |filed_value|
      case filed_value
      when Array
        filed_value.join(',')
      when TrueClass
        '是'
      when FalseClass
        '否'
      else
        filed_value
      end
    end
  end

  def data_ransack_file!(records, entities_class, opts = {})
    thead = opts.delete(:thead)
    thead.push('创建时间')

    file_name       = opts.delete(:file_name) || 'export'
    opts[:use_base] = false

    data = opts.delete(:data) || file_records!(records, entities_class, opts).as_json
    p    = Axlsx::Package.new

    p.workbook.add_worksheet(name: '数据列表') do |sheet|
      types  = Array.new(thead.length, :string)
      widths = Array.new(thead.length, 13)

      sheet.add_row thead, widths: widths, height: 30, sz: 13 if thead.present?

      data.each do |row|
        row.delete(:id) if opts[:without_id]

        sheet.add_row format_file_values(row.values), widths: widths, types: types, height: 30, sz: 12
      end
    end

    p.use_shared_strings = true

    content_type 'application/octet-stream'
    header['Access-Control-Expose-Headers'] = 'Content-Disposition'
    header['Content-Disposition']           = "attachment; filename=#{ERB::Util.url_encode(file_name)}.xlsx"
    env['api.format']                       = :binary
    p.to_stream.read
  end

  def file_records!(records, entities_class, opts = {})
    records.each.map do |record|
      if record.is_a?(Hash)
        entities_record_no_base(record[:record], entities_class, opts.merge(record))
      else
        entities_record_no_base(record, entities_class, opts)
      end
    end
  end

  def data_record!(record, entities_class, meta = {})
    opts = meta.delete(:opts) || {}
    opts.merge!(default_opts)

    {
      meta: default_meta.merge(meta),
      data: entities_record(record, entities_class, opts)
    }
  end

  def data_records!(records, entities_class, meta = {})
    opts = meta.delete(:opts) || {}
    opts.merge!(default_opts)

    {
      meta: default_meta.merge(meta),
      data: json_records!(records, entities_class, opts)
    }
  end

  def json_records!(records, entities_class, opts = {})
    return if records.nil?

    opts.merge!(default_opts)
    records.map.each_with_index { |record, index| entities_record(record, entities_class, opts.merge(rank: base_num(records) + index + 1)) }
  end

  def entities_record(record, entities_class, opts = {})
    opts ||= {}
    Entities::RecordBase.represent record, opts.merge(glass: entities_class)
  end

  # 转换为 hash, 一般在 service 中使用
  def entities_hash(record, entities_class, opts = {})
    return {} if record.blank?

    json_str = entities_class.represent(record, opts).to_json
    return {} if json_str.blank?

    JSON.parse(json_str)
  end

  def entities_record_no_base(record, entities_class, opts = {})
    opts ||= {}
    entities_class.represent record, opts
  end

  def ancestry_tree(arrange_records, entity)
    arrange_records.each.map do |parent, children|
      attrs            = entity.represent(parent).as_json
      attrs[:children] = ancestry_tree(children, entity) if children.present?

      attrs
    end
  end

  private

  def base_meta
    request = Grape::Request.new(env)
    {
      message:       I18n.t_message('success'),
      path:          request.path,
      status:        200,
      refresh_token: @refresh_token,
      version:       request.path.match(%r{/v(\d+)/}).try(:[], 1)
    }
  end

  def default_meta
    meta                = base_meta
    meta[:payload]      = @payload || {}
    meta[:current_user] = Entities::User::Simple.represent current_user

    meta
  end

  def pagination(records)
    {
      pagination: {
        total_pages:   records.try(:total_pages),
        current_page:  records.try(:current_page),
        current_count: records.try(:length),
        limit_value:   records.try(:limit_value),
        total_count:   records.try(:total_count),
        prev_page:     records.try(:prev_page),
        next_page:     records.try(:next_page)
      }
    }
  end
end
# rubocop:enable Metrics/AbcSize,Metrics/ModuleLength
