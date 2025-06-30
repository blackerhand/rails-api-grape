module FootmarkHelper
  def footmarkable!(record)
    return unless current_user
    return if record.nil?

    @footmark = Footmark.find_or_initialize_by(owner: current_user, footmarkable: record)
    @footmark.update!(updated_at: Time.current)

    record.increment!(:click_number) if record.respond_to?(:click_number)
  end
end
