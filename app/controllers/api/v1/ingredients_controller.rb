module Api
  module V1
    class IngredientsController < ::Api::ApplicationController
      include JsonResponseHelper
      include ActiveModel::Validations
      before_action :authorize_request, except: :index
      before_action :load_company
      before_action :load_ingredient, except: %i[create index]

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

      def show
        show_response(ingredient, serializer, 'show')
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

      def ingredient
        @ingredient ||= ::Ingredient.find_by(id: params[:id])
      end

      def load_ingredient
        return ingredient_not_found unless ingredient
      end

      def ingredient_not_found
        errors.add(:ingredient, 'not found')
        resource = error_serializer.serialize(errors)
        render json: resource,
               each_serializer: serializer,
               adapter: :json_api,
               key_transform: :underscore,
               status: status(resource)
      end
    end
  end
end
