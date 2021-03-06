class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email(user_id)
    @user = User.find_by(id: user_id)
    mail(to: @user.email, subject: 'Welcome to My Recipe Site')
  end
end
