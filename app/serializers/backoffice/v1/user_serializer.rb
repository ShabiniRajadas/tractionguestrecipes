module Backoffice
  module V1
    class UserSerializer < ActiveModel::Serializer
      type 'user'
      attributes :name, :email
    end
  end
end
