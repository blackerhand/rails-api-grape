module ApplicationHelper
  include ParamsHelper
  include ResourceHelper

  def current_user
    return @current_user if @current_user.present?
    return if @payload.blank?

    @current_user = User.find_by(id: @payload['id'])
  end

  def current_user_id
    current_user.try(:id)
  end

  def current_record
    return if params.id.nil? || record_class.nil?

    @current_record ||= record_class.enabled.find(params.id)
  end

  def page_per
    params[:per] || GRAPE_API::PER_PAGE
  end

  def params_page
    params[:page] || 1
  end

  def upload_file(file_type, params_file)
    file_class = file_type.safe_constantize
    valid_error!('文件类型不正确') if file_class.nil?
    valid_error!('同一种类型的文件只能上传一个, 请删除后重试') if file_class.enabled.exists?(fileable: current_record)

    @file_object = file_class.create!(fileable: current_record, file: params_file)
  end
end
