# == Schema Information
#
# Table name: global_settings
#
#  id                :bigint           not null, primary key
#  desc(描述)        :string(255)
#  disabled_at       :datetime
#  key(键)           :string(255)
#  value(值)         :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  created_user_id   :bigint
#  updated_user_id   :bigint
#  user_id(用户ID)   :bigint
#
# Indexes
#
#  index_global_settings_on_created_user_id  (created_user_id)
#  index_global_settings_on_disabled_at      (disabled_at)
#  index_global_settings_on_key_and_user_id  (key,user_id) UNIQUE
#  index_global_settings_on_user_id          (user_id)
#
class GlobalSetting < ApplicationRecord
  scope :global_settings, -> { where(user_id: nil) }

  belongs_to :user, optional: true
  validates :key, presence: true, uniqueness: { scope: :user_id }

  def self.set(key:, value:, desc: nil, user_id: nil)
    setting = find_or_initialize_by(key: key, user_id: user_id)
    setting.update(value: value, desc: desc)
  end

  def self.settings(user_id)
    # user_id desc => 1, nil, 用户配置高于全局配置 1 > nil
    setting_records = where(user_id: [user_id, nil]).order(user_id: :desc)

    setting_records.each_with_object(Hashie::Mash.new) do |setting, result|
      result[setting.key] ||= setting.value
    end
  end
end
