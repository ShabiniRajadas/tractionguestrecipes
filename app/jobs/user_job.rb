class UserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    UserMailer.welcome_email(user).deliver_later
  end
end
