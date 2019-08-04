module Api
  module V1
    class SubRecipesController < ::Api::ApplicationController
      include JsonResponseHelper
      include ActiveModel::Validations
      before_action :authorize_request, except: :index
      before_action :load_company
      before_action :load_sub_recipe, except: %i[create index]

      def index
        sub_recipes = SubRecipe.where(company_id: company.id)
        show_response(sub_recipes, serializer, action_name)
      end

      def create
        sub_r = SubRecipe.new(permitted_params)
        sub_r.company = company
        sub_r.uid = SecureRandom.uuid
        sub_r.measurement_unit = measurement_unit
        ing_result = sub_r.save ? sub_recipe_ingredients(sub_r) : sub_recipe_invalid
        result = ing_result ? sub_r : error_response(sub_r.errors)
        show_response(result, serializer, action_name)
      end

      def show
        show_response(sub_recipe, serializer, 'show')
      end

      def update
        sub_recipe.assign_attributes(permitted_params)
        sub_recipe.measurement_unit = measurement_unit
        result = sub_recipe.save ? sub_recipe.reload : sub_recipe.errors
        show_response(result, serializer, action_name)
      end

      def destroy
        sub_recipe.destroy
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
        ::Api::V1::SubRecipeSerializer
      end

      def measurement_unit
        SubRecipe::MEASUREMENT_UNIT[permitted_params[:measurement_unit]]
      end

      def sub_recipe
        @sub_recipe ||= ::SubRecipe.find_by(id: params[:id])
      end

      def load_sub_recipe
        return sub_recipe_not_found unless sub_recipe
      end

      def sub_recipe_not_found
        errors.add(:sub_recipe, 'not found')
        resource = error_serializer.serialize(errors)
        render json: resource,
               each_serializer: serializer,
               adapter: :json_api,
               key_transform: :underscore,
               status: status(resource)
      end

      def sub_recipe_invalid
        errors.add(:sub_recipe, 'invalid')
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

      def sub_recipe_ingredients(sub_recipe)
        ingredient_list.each do |data|
          SubRecipeIngredient.create(sub_recipe_id: sub_recipe.id, ingredient_id: data[:ingredient_id], quantity: data[:quantity])
        end
        true
      end
    end
  end
end
