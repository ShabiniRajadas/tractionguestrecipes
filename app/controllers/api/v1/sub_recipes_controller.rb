module Api
  module V1
    class SubRecipesController < ::Api::ApplicationController
      include JsonResponseHelper
      include ActiveModel::Validations
      before_action :authorize_request, except: :index
      before_action :load_company

      def index
        sub_recipes = SubRecipe.where(company_id: company.id)
        show_response(sub_recipes, serializer, action_name)
      end

      def create
        # shortened sub_recipe to sub_r because of rubocop linelength
        sub_r = SubRecipe.new(permitted_params)
        sub_r.company = company
        sub_r.uid = SecureRandom.uuid
        sub_r.measurement_unit = measurement_unit
        result = sub_r.save ? sub_r : error_response(sub_r.errors)
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
        ::Api::V1::SubRecipeSerializer
      end

      def measurement_unit
        SubRecipe::MEASUREMENT_UNIT[permitted_params[:measurement_unit]]
      end
    end
  end
end
