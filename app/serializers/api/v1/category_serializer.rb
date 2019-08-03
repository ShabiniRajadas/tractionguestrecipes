module Api
  module V1
    class CategorySerializer < ActiveModel::Serializer
      type 'category'
      attributes :id, :name, :description, :uid, :company_uid

      def company_uid
        object&.company&.uid
      end
    end
  end
end
