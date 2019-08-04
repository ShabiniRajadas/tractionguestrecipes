class SubRecipe < ApplicationRecord
  has_many :sub_recipe_ingredients
  has_many :ingredients, through: :sub_recipe_ingredients

  validates :name, presence: true
end
