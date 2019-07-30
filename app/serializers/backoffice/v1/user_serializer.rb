module Backoffice
  module V1
    class UserSerializer < ActiveModel::Serializer
      type 'user'
      attributes :email
    end
  end
end
