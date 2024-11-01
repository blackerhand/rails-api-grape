module FootmarkHelper
  def footmarkable!(record)
    return unless current_user
    return if record.nil?

    @footmark = Footmark.find_or_initialize_by(owner: current_user, footmarkable: record)
    @footmark.update!(updated_at: Time.current)
  end
end
