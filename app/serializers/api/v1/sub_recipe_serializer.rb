module Api
  module V1
    class SubRecipeSerializer < ActiveModel::Serializer
      type 'sub_recipe'
      attributes :name, :description, :measurement_unit, :unit_price, :uid,
                 :company_uid

      def company_uid
        object&.company&.uid
      end

      def measurement_unit
        ::SubRecipe::MEASUREMENT_UNIT.index(object&.measurement_unit)
      end
    end
  end
end
