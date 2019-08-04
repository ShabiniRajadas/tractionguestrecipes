module Api
  module V1
    class RecipeSerializer < ActiveModel::Serializer
      type 'recipe'
      attributes :name, :description, :measurement_unit, :unit_price, :uid,
                 :company_uid, :ingredient_names

      def company_uid
        object&.company&.uid
      end

      def measurement_unit
        ::Recipe::MEASUREMENT_UNIT.index(object&.measurement_unit)
      end

      def ingredient_names
        object&.ingredients.pluck(:name).join(', ')
      end
    end
  end
end
