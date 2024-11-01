module PreEnum
  extend ActiveSupport::Concern

  # 省略英文 name, 直接匹配中文和数字
  module ClassMethods
    def str_enum(enum_name)
      class_eval do
        define_singleton_method "#{enum_name}_for_select".to_sym do
          I18n.t_activerecord(name.underscore, "#{enum_name}_names")
        end

        define_method "#{enum_name}_name".to_sym do
          field_en = send(enum_name.to_sym).to_s.to_sym

          i18ns = self.class.send("#{enum_name}_for_select")
          return field_en if i18ns.blank?
          return i18ns if i18ns.is_a?(String)

          i18ns[field_en]
        end
      end
    end

    def pre_enum(definitions)
      enum_name = definitions.keys.first
      enum(**definitions)

      class_eval do
        define_singleton_method "#{enum_name}_for_select".to_sym do
          I18n.t_activerecord(name.underscore, "#{enum_name}_names")
        end

        # Model.enum_type_zh_for_index('option_1')  => 1
        define_singleton_method "#{enum_name}_zh_for_index".to_sym do |index|
          definitions.values.first.select { |_k, v| v.to_s == index.to_s }.keys.first
        end

        # object.enum_name => 选项 1
        define_method "#{enum_name}_name".to_sym do
          field_en = send(enum_name.to_sym).to_s.to_sym

          i18ns = self.class.send("#{enum_name}_for_select")
          return field_en if i18ns.blank?
          return i18ns if i18ns.is_a?(String)

          i18ns[field_en]
        end

        # object.enum_index => 1
        define_method "#{enum_name}_index".to_sym do
          send "#{enum_name}_before_type_cast".to_sym
        end
      end
    end
  end
end
