module Api
  module V1
    class RecipesController < ::Api::ApplicationController
      include JsonResponseHelper
      include ActiveModel::Validations
      before_action :authorize_request, except: :index
      before_action :load_company
      before_action :load_recipe, except: %i[create index]

      def index
        recipes = Recipe.where(company_id: company.id)
        show_response(recipes, serializer, action_name)
      end

      def create
        rec = Recipe.new(permitted_params)
        rec.company = company
        rec.uid = SecureRandom.uuid
        rec.measurement_unit = measurement_unit
        ing_result = rec.save ? recipe_ingredients(rec) : recipe_invalid
        result = ing_result ? rec : error_response(rec.errors)
        show_response(result, serializer, action_name)
      end

      def show
        show_response(recipe, serializer, 'show')
      end

      def update
        recipe.assign_attributes(permitted_params)
        recipe.measurement_unit = measurement_unit
        result = recipe.save ? recipe.reload : recipe.errors
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
              .permit(:name,
                      :description, :unit_price, :measurement_unit,
                      ingredients: [])
      end

      def serializer
        ::Api::V1::RecipeSerializer
      end

      def measurement_unit
        Recipe::MEASUREMENT_UNIT[permitted_params[:measurement_unit]]
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
        render json: resource,
               each_serializer: serializer,
               adapter: :json_api,
               key_transform: :underscore,
               status: status(resource)
      end

      def recipe_invalid
        errors.add(:recipe, 'invalid')
        resource = error_serializer.serialize(errors)
        render json: resource,
               each_serializer: serializer,
               adapter: :json_api,
               key_transform: :underscore,
               status: status(resource)
      end

      def ingredient_list
        array = []
        params[:data][:attributes][:ingredients].each do |data|
          ing = {}
          ing[:ingredient_id] = find_ingredient(data[:uid]).id unless find_ingredient(data[:uid]).blank?
          ing[:quantity] = data[:quantity]
          array << ing
        end
        array
      end

      def find_ingredient(uid)
        ::Ingredient.find_by(uid: uid)
      end

      def recipe_ingredients(recipe)
        ingredient_list.each do |data|
          RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: data[:ingredient_id], quantity: data[:quantity])
        end
        true
      end
    end
  end
end
