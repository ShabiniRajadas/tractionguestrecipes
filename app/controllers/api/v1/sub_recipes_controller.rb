module Api
  module V1
    class SubRecipesController < ::Api::ApplicationController
      include JsonResponseHelper
      include ActiveModel::Validations
      before_action :load_company

      def index
        sub_recipes = SubRecipe.where(company_id: company.id)
        show_response(sub_recipes, serializer, action_name)
      end

      private

      def serializer
        ::Api::V1::SubRecipeSerializer
      end
    end
  end
end
