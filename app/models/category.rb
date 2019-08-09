class Category < ApplicationRecord
  validates :name, presence: true
  belongs_to :company
  has_many :recipes
  accepts_nested_attributes_for :recipes, allow_destroy: true
end
