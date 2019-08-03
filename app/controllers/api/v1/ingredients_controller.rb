class Api::V1::IngredientsController < ::Api::ApplicationController
	include JsonResponseHelper
      include ActiveModel::Validations
      before_action :authorize_request, except: :index
      before_action :load_company

      def index
        categories = Ingredient.where(company_id: company.id)
        show_response(categories, serializer, action_name)
      end

      private

      def serializer
        ::Api::V1::IngredientSerializer
      end
end
