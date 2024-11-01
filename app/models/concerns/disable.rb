module Disable
  extend ActiveSupport::Concern

  included do
    scope :disabled, -> { where.not(disabled_at: nil) }
    scope :enabled, -> { where(disabled_at: nil).order(id: :desc) }
    scope :enabled_asc, -> { where(disabled_at: nil).order(id: :asc) }

    belongs_to :owner, class_name: 'User', foreign_key: 'created_user_id', optional: true
    belongs_to :modifier, class_name: 'User', foreign_key: 'updated_user_id', optional: true

    def enabled?
      disabled_at.blank?
    end

    def disabled?
      disabled_at.present?
    end

    def disabled_desc
      I18n.t("activerecord.attributes.disabled_names.#{enabled? ? 'enabled' : 'disabled'}")
    end

    def self.disabled_all
      update_all(disabled_at: Time.current)
    end

    def disabled!
      raise RecordAlreadyDisabled, '已删除, 不能再次删除' unless enabled?

      ActiveRecord::Base.transaction do
        before_disabled
        update!(disabled_at: Time.current)
      end
    end

    def enabled!
      update!(disabled_at: nil)
    end

    def before_disabled; end

    before_create do
      self.created_user_id ||= PaperTrail.request.whodunnit
    end

    before_update do
      self.updated_user_id ||= PaperTrail.request.whodunnit
    end

    before_destroy do
      self.updated_user_id ||= PaperTrail.request.whodunnit
    end
  end
end
