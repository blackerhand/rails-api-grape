module ValidHelper
  def valid_ids!(ids, model_class)
    return [] if ids.blank?

    ids     = [ids] unless ids.is_a?(Array)
    records = model_class.where(id: ids)
    valid_error!("#{I18n.t_activerecord(model_class)} #{I18n.t_message('ids_error')}") unless ids.length == records.size

    records
  end
end
