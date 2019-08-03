class Ingredient < ApplicationRecord
  validates :name, :unit_price, presence: true
  belongs_to :company

  MEASUREMENT_UNIT = {"grams" => 1,
  					"millilitres" => 2}
end
