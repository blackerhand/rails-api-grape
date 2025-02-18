module List
  class GlobalSettingSerializer < ApplicationSerializer
    attributes :key, :desc, :value, :user_id

    lazy_belongs_to :user
    lazy_has_one :files_setting_files, serializer: FileObjectSerializer
  end
end
