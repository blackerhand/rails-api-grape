module ApplicationHelper
  def current_user
    return @current_user if @current_user.present?
    return if @payload.blank?

    @current_user = User.find_by(id: @payload['id'])
  end

  def update_current_user(user, remember)
    @current_user = user
    @payload      = @current_user.payload.merge(remember: remember).stringify_keys
  end

  def current_user_id
    current_user.try(:id)
  end

  def set_locale
    locale = params[:locale] ||
      @payload.try(:[], 'settings').try(:[], 'locale')
    return if locale.blank?

    I18n.locale = locale
  end

  def current_record
    @current_record ||= current_scope.find(params.id)
  end

  def owner_record
    @owner_record ||= owner_scope.find(params.id)
  end

  def current_scope
    record_class.enabled
  end

  def owner_scope
    current_scope.where(owner: current_user)
  end

  def upload_file(file_type, params_file)
    file_class = file_type.safe_constantize
    valid_error!('文件类型不正确') if file_class.nil?
    valid_error!('同一种类型的文件只能上传一个, 请删除后重试') if file_class.enabled.exists?(fileable: current_record)

    @file_object = file_class.create!(fileable: current_record, file: params_file)
  end

  def logger(message)
    Rails.logger.info("message: #{message}")
  end
end
