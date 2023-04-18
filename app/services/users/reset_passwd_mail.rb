module Users
  class ResetPasswdMail < BaseService
    def initialize (email)
      @email = email
      @user  = User.find_by(email: @email)
    end

    def execute
      return false, '用户不存在' if @user.nil?
      return false, '发送频繁, 请稍后重试' if send_number >= 3

      @user.gen_code!
      UserMailer.with(user: @user).reset_email.deliver_now
      set_cache

      [true, 'success']
    end

    def set_cache
      Rails.cache.write cache_key, send_number + 1, expires_in: 10.minutes
    end

    def cache_key
      "user_reset_passwd_mail_#{@user.id}"
    end

    def send_number
      @send_number ||= Rails.cache.fetch(cache_key, expires_in: 10.minutes) || 0
    end
  end
end
