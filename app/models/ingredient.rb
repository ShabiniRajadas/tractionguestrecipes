class Ingredient < ApplicationRecord
  validates :name, :unit_price, presence: true
  belongs_to :company

  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients

  MEASUREMENT_UNIT = { 'grams' => 1,
                       'millilitres' => 2 }.freeze
end
