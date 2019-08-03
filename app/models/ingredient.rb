class Ingredient < ApplicationRecord
  validates :name, :unit_price, presence: true
  belongs_to :company
end
