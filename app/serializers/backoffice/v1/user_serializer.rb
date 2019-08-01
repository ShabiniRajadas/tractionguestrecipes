module Backoffice
  module V1
    class UserSerializer < ActiveModel::Serializer
      type 'user'
      attributes :email, :company_uid

      def company_uid
        object&.company&.uid
      end
    end
  end
end
