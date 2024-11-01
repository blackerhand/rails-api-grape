module ActiveSupport
  class TimeWithZone
    def as_json(options = nil)
      time.strftime('%F %T')
    end
  end
end
