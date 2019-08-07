class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email(user)
    p '--------------USER MAIL SENT--------'
    p user
    @user = user
    mail(to: @user.email, subject: 'Welcome to My Recipe Site')
  end
end
