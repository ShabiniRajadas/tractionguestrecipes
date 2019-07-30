module Backoffice
  module V1
    class UserSerializer < ActiveModel::Serializer
      type 'user'
      attributes :id, :name, :email
    end
  end
end
