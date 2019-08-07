class UserJob < ApplicationJob
  queue_as :default

  def perform(user)
    p '-=-=-=TESTing-=-=-'
    p user
    UserMailer.welcome_email(user).deliver_now
  end
end
