# Services 层
class BaseService
  include NotifyHelper
  include FormatHelper

  def self.execute(*args)
    new(*args).execute
  end

  def execute
    raise NotImplementedError
  end

  def current_user
    @current_user ||= User.find_by(id: PaperTrail.request.whodunnit)
  end

  def check_error!(message)
    raise ServiceCheckError, I18n.t_message(message) || message
  end

  def check_client!(client, message)
    return if client.response_valid?

    check_error!("第三方请求失败: #{message}, 返回结果: #{client.response_data}")
  end

  def job_stop_error!(message)
    raise ServiceStopError, I18n.t_message(message) || message
  end

  def job_retry_error!(message)
    raise ServiceRetryError, I18n.t_message(message) || message
  end

  def client_request_error!(message)
    raise ClientRequestError, I18n.t_message(message) || message
  end

  def raise_error!(error, message)
    raise error, I18n.t_message(message)
  end

  def diff_change(group1, group2, uniq_key, uniq_key_2 = nil)
    uniq_key_2 ||= uniq_key
    gg1        = group1.group_by(&uniq_key)
    gg2        = group2.group_by(&uniq_key_2)

    (gg1.keys + gg2.keys).uniq.each do |key|
      group1_item = gg1[key]&.first
      group2_item = gg2[key]&.first

      change_mode =
        if group1_item.present? && group2_item.present?
          :no_change
        elsif group1_item.blank?
          :add
        elsif group2_item.blank?
          :remove
        end

      yield(group1_item, group2_item, change_mode)
    end
  end

  def update_attrs!(attrs, glass, unique_keys)
    return if attrs.blank?

    unique_attrs = attrs.slice(*unique_keys)

    record = glass.find_or_initialize_by(unique_attrs)
    record.set_origin_data(attrs[:origin_data]) if attrs.key?(:origin_data)
    record.update!(attrs)

    record
  end

  def underscore_keys(hash)
    hash.deep_transform_keys! { |key| key.to_s.underscore }
  end

  def valid_error!(message)
    check_error!(message)
  end
end
