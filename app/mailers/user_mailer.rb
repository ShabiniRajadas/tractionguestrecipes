class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email(user)
    p '--------------TESTING AGAIN'
    @user = user
    mail(to: @user.email, subject: 'Welcome to My Recipe Site')
  end
end
