module Api
  module V1
    class IngredientSerializer < ActiveModel::Serializer
      type 'ingredient'
      attributes :name, :description, :measurement_unit, :unit_price, :uid,
                 :company_uid

      def company_uid
        object&.company&.uid
      end

      def measurement_unit
        ::Ingredient::MEASUREMENT_UNIT.index(object&.measurement_unit)
      end
    end
  end
end
