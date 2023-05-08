class UserMailer < ApplicationMailer
  def welcome_email
    mail(to: '308820773@qq.com', subject: 'test')
  end

  def reset_email
    @user = params[:user]
    mail(to: @user.email, subject: 'test')
  end
end
