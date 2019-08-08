module Api
  module V1
    class RecipeSerializer < ActiveModel::Serializer
      include Rails.application.routes.url_helpers
      type 'recipe'
      attributes :name, :description, :measurement_unit, :unit_price, :uid,
                 :company_uid, :category_uid, :ingredient_names, :photo_url

      def company_uid
        object&.company&.uid
      end

      def measurement_unit
        ::Recipe::MEASUREMENT_UNIT.index(object&.measurement_unit)
      end

      def category_uid
        object&.category&.uid
      end

      def ingredient_names
        object&.ingredients&.pluck(:name)&.join(', ')
      end

      def photo_url
        rails_blob_path(object.photo, only_path: true) if object.photo.attached?
      end
    end
  end
end
