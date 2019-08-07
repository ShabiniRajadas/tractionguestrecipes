class UserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
  	p "USER ID DETAILS"
  	p user_id
    user = User.find_by(id: user_id)
    p user
    UserMailer.welcome_email(user).deliver_now
  end
end
