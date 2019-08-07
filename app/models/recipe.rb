class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  accepts_nested_attributes_for :ingredients
  has_one_attached :photo

  belongs_to :company
  belongs_to :category

  validates :name, presence: true

  MEASUREMENT_UNIT = { 'grams' => 1,
                       'millilitres' => 2,
                       'count' => 3 }.freeze
end
