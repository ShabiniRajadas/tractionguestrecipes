class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true
  belongs_to :company
  after_create :send_mail

  USER_STATUS = { 'created' => 1,
                  'approved' => 2,
                  'deleted' => 3 }.freeze

  def send_mail
    UserMailer.with(user_id: id).welcome_email.deliver_now
  end
end
