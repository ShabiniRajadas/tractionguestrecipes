module Api
  module V1
    class RecipesService
      include ActiveModel::Validations
      include JsonResponseHelper

      def initialize(recipe, params, company)
        @recipe = recipe
        @recipe_params = params[:data][:attributes]
        @company = company
      end

      def create
        @recipe.assign_attributes(company: @company,
                                  uid: SecureRandom.uuid,
                                  measurement_unit: measurement_unit,
                                  category: find_category)
        ingredients = @recipe.save ? recipe_ingredients : error_response(@recipe.errors)
        created?(ingredients)
      end

      def update; end

      private

      def find_category
        ::Category.find_by(uid: @recipe_params[:category_id])
      end

      def measurement_unit
        Recipe::MEASUREMENT_UNIT[@recipe_params[:measurement_unit]]
      end

      def recipe_ingredients
        ingredient_list.each do |data|
          RecipeIngredient.create(recipe_id: @recipe.id,
                                  ingredient_id: data[:ingredient_id],
                                  quantity: data[:quantity])
        end
        true
      end

      def ingredient_list
        array = []
        @recipe_params[:ingredients].each do |data|
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

      def created?(ingredients)
        ingredients == true ? @recipe : ingredients
      end
    end
  end
end
