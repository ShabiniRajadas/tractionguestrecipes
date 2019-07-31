class User < ApplicationRecord
	has_secure_password
  validates :email, presence: true

  USER_STATUS = { 'created' => 1,
                  'approved' => 2,
                  'deleted' => 3 }.freeze
end
