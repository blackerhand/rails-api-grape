# == Schema Information
#
# Table name: users
#
#  id                            :bigint           not null, primary key
#  code(验证码)                  :string(6)
#  disabled_at                   :datetime
#  email(邮箱)                   :string(100)
#  follows_count(关注数)         :integer          default(0)
#  gender(性别)                  :integer
#  last_sign_in_at(最后登录时间) :datetime
#  nickname(昵称)                :string(100)
#  password_digest               :string
#  user_type                     :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  created_user_id               :bigint
#  updated_user_id               :bigint
#
# Indexes
#
#  index_users_on_created_user_id  (created_user_id)
#  index_users_on_disabled_at      (disabled_at)
#  index_users_on_email            (email) UNIQUE
#  index_users_on_nickname         (nickname)
#  index_users_on_user_type        (user_type)
#
class User < ApplicationRecord
  include Users::Actionable
  include Users::Rolifiable
  include SourceChannel

  has_secure_password

  has_one_fileable Files::Avatar

  validates :email, presence: true, uniqueness: true

  after_create :create_files_avatar!

  pre_enum user_type: {
    Admin: 0, # 管理员
    User: 1, # 学生
  }, _prefix:         true


  def settings
    return @settings if defined?(@settings)

    {
      locale: GlobalSetting.get(key: 'locale', user_id: id)
    }
  end

  def payload
    slice(:id, :type, :settings,
          :can_access_admin,)
  end

  def avatar_url
    files_avatar.file_url
  end

  def self.build_with!(payload = {})
    payload = Hashie::Mash.new(payload) rescue Hashie::Mash.new
    user = find_by(id: payload.id)
    I18n.t_message('user_not_exists') if user.nil?

    user
  end

  def gen_code!
    update!(code: rand(999_999).to_s.rjust(6, '0'))
    code
  end
end
