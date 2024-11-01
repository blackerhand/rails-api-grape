module HasFileable
  extend ActiveSupport::Concern
  # attr_accessor :files_attachment_id
  # has_one :files_attachment, :class_name => 'Files::Attachment', as: :fileable

  module ClassMethods
    def has_one_fileable(file_class)
      file_association        = file_class.to_s.underscore.tr('/', '_').to_sym
      file_association_id     = "#{file_association}_id".to_sym
      instance_variables_name = "@#{file_association_id}".to_sym

      attr_writer file_association_id
      has_one file_association, class_name: file_class.to_s, as: :fileable, dependent: :destroy

      # 定义 reader 方法, 防止其他库覆盖, 例如 fast_jsonapi, jsonapi-serializer
      define_method file_association_id do
        if instance_variables.include?(instance_variables_name)
          instance_variable_get(instance_variables_name)
        else
          send("#{file_association}")&.id
        end
      end

      before_validation do
        new_id = instance_variable_get(instance_variables_name)
        next if new_id.nil?
        next send("#{file_association}=", nil) if new_id == 0
        next if send("#{file_association}")&.id == new_id

        file = file_class.not_association_by_owner(PaperTrail.request.whodunnit).find_by!(id: new_id)
        send("#{file_association}=", file)
      end
    end

    def has_many_fileables(file_class)
      file_association        = file_class.to_s.underscore.tr('/', '_').to_sym
      file_associations       = file_association.to_s.pluralize.to_sym
      file_association_ids    = "#{file_association}_ids".to_sym
      instance_variables_name = "@#{file_association_ids}".to_sym

      attr_writer file_association_ids
      has_many file_associations, class_name: file_class.to_s, as: :fileable, dependent: :destroy

      define_method file_association_ids do
        if instance_variables.include?(instance_variables_name)
          instance_variable_get(instance_variables_name)
        else
          send("#{file_associations}").pluck(:id)
        end
      end

      before_validation do
        new_ids = instance_variable_get(instance_variables_name)
        next if new_ids.nil? || !new_ids.is_a?(Array)

        new_ids = new_ids.compact.map(&:to_i)
        next send("#{file_associations}=", []) if new_ids.blank?

        old_ids = send("#{file_associations}").pluck(:id)
        next if old_ids == new_ids

        # 注意保存顺序
        files = new_ids.map do |new_id|
          if old_ids.include?(new_id)
            file_class.find_by!(id: new_id)
          else
            file_class.not_association_by_owner(PaperTrail.request.whodunnit).find_by!(id: new_id)
          end
        end
        send("#{file_associations}=", files)
      end
    end
  end
end
