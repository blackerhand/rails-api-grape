module ValidHelper
  def valid_ids!(ids, model_class)
    return true if ids.blank?

    ids = [ids] unless ids.is_a?(Array)
    ids.length == model_class.where(id: ids).size
  end
end
