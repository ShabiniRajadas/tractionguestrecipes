class SubRecipeIngredient < ApplicationRecord
  belongs_to :sub_recipe
  belongs_to :ingredient
end
