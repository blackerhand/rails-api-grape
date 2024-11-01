module SourceChannel
  extend ActiveSupport::Concern

  included do
    serialize :original_data, JSON

    pre_enum channel: { system:   0,
                        canvas:   1,
                        yuketang: 2,
                        xunke:    3,
                        ai:       4 }, _prefix: true
  end
end
