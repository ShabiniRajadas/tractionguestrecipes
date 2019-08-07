class Category < ApplicationRecord
  validates :name, presence: true
  belongs_to :company
  has_many :recipes
end
