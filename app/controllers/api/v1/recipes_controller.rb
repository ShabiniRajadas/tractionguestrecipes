module Api
  module V1
    class RecipesController < ::Api::ApplicationController
      include JsonResponseHelper
      include ActiveModel::Validations
      before_action :authorize_request, except: :index
      before_action :load_company
      before_action :load_recipe, except: %i[create index]
      before_action :ingredients_invalid, only: :create

      def index
        recipes = Recipe.where(company_id: company.id)
        show_response(recipes, serializer, action_name)
      end

      def create
        recipe = Recipe.new(permitted_params)
        result = RecipesService.new(recipe, params, company).create
        show_response(result, serializer, action_name)
      end

      def show
        show_response(recipe, serializer, 'show')
      end

      def update
        recipe.assign_attributes(permitted_params)
        result = RecipesService.new(recipe, params, company).update
        show_response(result, serializer, action_name)
      end

      def destroy
        recipe.destroy
        head :no_content
      end

      private

      def permitted_params
        params.require(:data)
              .require(:attributes)
              .permit(:name, :description, :unit_price,
                      :measurement_unit, :category_id, ingredients: [])
      end

      def serializer
        ::Api::V1::RecipeSerializer
      end

      def recipe
        @recipe ||= ::Recipe.find_by(id: params[:id])
      end

      def load_recipe
        return recipe_not_found unless recipe
      end

      def recipe_not_found
        errors.add(:recipe, 'not found')
        resource = error_serializer.serialize(errors)
        show_response(resource, serializer)
      end

      def ingredients_invalid
        return ingredients_error unless valid_ingredients(ingredient_uids)
      end

      def ingredients_error
        errors.add(:recipe_ingredients, 'are invalid')
        resource = error_serializer.serialize(errors)
        show_response(resource, serializer)
      end

      def ingredient_uids
        params[:data][:attributes][:ingredients]
      end

      def valid_ingredients(ingredient_uids)
        ings_objects = ingredient_uids.map { |c| c[:uid] }
        actual_ings = Ingredient.where(uid: ings_objects)
        actual_ings.count == ingredient_uids.size
      end
    end
  end
end
