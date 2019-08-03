module Api
  module V1
    class IngredientSerializer < ActiveModel::Serializer
      type 'ingredient'
      attributes :name, :description, :measurement_unit, :unit_price,
                 :company_uid

      def company_uid
        object&.company&.uid
      end
    end
  end
end
