module Api
  module V1
    class IngredientsController < ::Api::ApplicationController
      include JsonResponseHelper
      include ActiveModel::Validations
      before_action :authorize_request, except: :index
      before_action :load_company

      def index
        categories = Ingredient.where(company_id: company.id)
        show_response(categories, serializer, action_name)
      end

      def create
        ing = Ingredient.new(permitted_params)
        ing.company = company
        ing.uid = SecureRandom.uuid
        ing.measurement_unit = Ingredient::MEASUREMENT_UNIT['grams']
        result = ing.save ? ing : error_response(ing.errors)
        show_response(result, serializer, action_name)
      end

      private

      def permitted_params
        params.require(:data)
              .require(:attributes)
              .permit(:name,
                      :description, :unit_price, :measurement_unit)
      end

      def serializer
        ::Api::V1::IngredientSerializer
      end
    end
  end
end
