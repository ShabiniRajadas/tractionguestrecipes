module Api
  module V1
    class RecipesController < ::Api::ApplicationController
      include JsonResponseHelper
      include ActiveModel::Validations
      before_action :authorize_request, except: :index
      before_action :load_company
      before_action :load_recipe, except: %i[create index]
      before_action :recipe_invalid, only: :create

      def index
        recipes = Recipe.where(company_id: company.id)
        show_response(recipes, serializer, action_name)
      end

      def create
        rec = Recipe.new(permitted_params)
        rec.assign_attributes(company: company,
                              uid: SecureRandom.uuid,
                              measurement_unit: measurement_unit,
                              category: find_category(permitted_params[:category_id]))
        ing_result = rec.save ? recipe_ingredients(rec) : error_response(rec.errors)
        if ing_result == true
          show_response(rec, serializer, action_name)
        else
          show_response(ing_result, serializer, action_name) if ing_result[:errors].present?
        end
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
                      :description,
                      :unit_price,
                      :measurement_unit,
                      :category_id,
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
        return recipe_invalid_error unless valid_ingredients(ingredient_uids)
      end

      def recipe_invalid_error
        errors.add(:recipe_ingredients, 'are invalid')
        resource = error_serializer.serialize(errors)
        render json: resource,
               each_serializer: serializer,
               adapter: :json_api,
               key_transform: :underscore,
               status: status(resource)
      end

      def ingredient_uids
        params[:data][:attributes][:ingredients]
      end

      def ingredient_list
        array = []
        ingredient_uids.each do |data|
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

      def find_category(uid)
        ::Category.find_by(uid: uid)
      end

      def valid_ingredients(ingredient_uids)
        ings_objects = ingredient_uids.map { |c| c[:uid] }
        actual_ings = Ingredient.where(uid: ings_objects)
        actual_ings.count == ingredient_uids.size
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
