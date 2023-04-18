module ExposeWithDoc
  extend ActiveSupport::Concern

  module ClassMethods
    def expose_with_doc(*fields)
      opts = {}

      if fields.last.is_a?(Hash)
        opts   = fields.last
        fields = fields[0..-2]
      end

      fields.each do |field|
        expose field, opts.merge(documentation: { desc: I18n.t_activerecord(model_name, field) })
      end
    end

    def model_name
      self.to_s.split("::")[1].underscore
    end
  end
end
