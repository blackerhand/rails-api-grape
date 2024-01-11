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
end
