class SubRecipe < ApplicationRecord
  has_many :sub_recipe_ingredients
  has_many :ingredients, through: :sub_recipe_ingredients

  belongs_to :company

  validates :name, presence: true

  MEASUREMENT_UNIT = { 'grams' => 1,
                       'millilitres' => 2,
                       'count' => 3 }.freeze
end
