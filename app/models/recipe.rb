class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  accepts_nested_attributes_for :ingredients

  belongs_to :company

  validates :name, presence: true

  MEASUREMENT_UNIT = { 'grams' => 1,
                       'millilitres' => 2,
                       'count' => 3 }.freeze
end
