module Api
  module V1
    class RecipesController < ::Api::ApplicationController
      include JsonResponseHelper
      include ActiveModel::Validations
      before_action :authorize_request, except: :index
      before_action :load_company
      before_action :load_recipe, except: %i[create index]
      before_action :ingredients_invalid, only: %i[create update]

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

      def upload_photo
        recipe.photo.attach(params[:photo])
        url_for(recipe.photo)
        recipe.save
        photo_uploaded(recipe)
        show_response(recipe, serializer, action_name)
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
        @recipe ||= ::Recipe.find_by(id: params[:id], company_id: company.id)
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
        return ingredients_error unless valid_ingredients
      end

      def ingredients_error
        errors.add(:recipe_ingredients, 'are invalid')
        resource = error_serializer.serialize(errors)
        show_response(resource, serializer)
      end

      def ingredient_uids
        params[:data][:attributes][:ingredients]
      end

      def valid_ingredients
        ings_objects = ingredient_uids.map { |c| c[:uid] }
        actual_ings = Ingredient.where(uid: ings_objects)
        actual_ings.count == ingredient_uids.size
      end

      def upload_error
        errors.add(:recipe, 'upload error')
        error_serializer.serialize(errors)
      end

      def photo_uploaded(recipe)
        recipe.photo.attached? ? recipe.reload : upload_error
      end
    end
  end
end
