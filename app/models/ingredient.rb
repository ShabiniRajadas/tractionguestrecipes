class Ingredient < ApplicationRecord
  validates :name, :unit_price, presence: true
  belongs_to :company

  has_many :sub_recipe_ingredients
  has_many :sub_recipes, through: :sub_recipe_ingredients

  MEASUREMENT_UNIT = { 'grams' => 1,
                       'millilitres' => 2 }.freeze
end
