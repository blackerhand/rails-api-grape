class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user   = user
    @record = record
  end

  def default_author
    true
  end

  def get?
    true
  end

  def post?
    login_required!
  end

  def get_id?
    enabled_required!
  end

  def put_id?
    owner_required! && enabled_required!
  end

  def delete_id?
    owner_required! && enabled_required!
  end

  private

  def login_required!
    raise Pundit::NotAuthorizedError, 'must be logged in' unless user

    true
  end

  def owner_required!
    login_required! && user.id == record.try(:user_id)
  end

  def enabled_required!(record_obj = record)
    raise ActiveRecord::RecordNotFound, "Couldn't find #{record_obj.class} with 'id'=#{record_obj.try(:id)}" if record_obj.try(:disabled?)

    true
  end
end
