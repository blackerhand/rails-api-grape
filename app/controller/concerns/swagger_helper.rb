module SwaggerHelper
  extend ActiveSupport::Concern

  module ClassMethods
    def swagger_desc(action_name, opts = {})
      i18n_msg = I18n.safe_t("api.#{action_name}") || {}

      summary_text = opts[:summary] || i18n_msg[:summary] || default_summary(action_name)
      tags_text    = opts[:tags] || default_tags
      entity_class = opts[:entity] || i18n_msg[:entity]&.safe_constantize || default_entity_class(action_name)

      desc summary_text do
        summary summary_text
        detail summary_text
        tags [tags_text]
        success entity_class
      end
    end

    def default_tags
      self.to_s.underscore.match(/api\/v\d+\/(.*\/.*)?_grape/)[1].gsub('/', '_')
    end

    def record_class
      self.to_s.split('::').last.gsub('Grape', '').singularize.classify.safe_constantize
    end

    def action_type(action_name)
      action_method = action_name.to_s.split('_').first

      if action_name.match(/_id$/)
        return :show if action_method == 'get'
        return :update if action_method == 'put'
        return :destroy if action_method == 'delete'
      end

      if action_name.match(/_#{record_class.to_s.underscore.pluralize}$/)
        return :index if action_method == 'get'
        return :create if action_method == 'post'
      end
    end

    def default_summary(action_name)
      record_i18n = I18n.safe_t("activerecord.models.#{record_class.to_s.underscore}")
      return if record_i18n.blank?

      case action_type(action_name)
      when :index
        "#{record_i18n}列表"
      when :show
        "#{record_i18n}详情"
      when :create
        "#{record_i18n}创建"
      when :update
        "#{record_i18n}更新"
      when :destroy
        "#{record_i18n}删除"
      end
    end

    def default_entity_class(action_name)
      case action_type(action_name)
      when :index
        "Entities::#{record_class}::List"
      when :show, :update, :destroy, :create
        "Entities::#{record_class}::Detail"
      end.to_s.safe_constantize
    end
  end
end
