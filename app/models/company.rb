class Company < ApplicationRecord
  validates :name, presence: true
  has_many :users
  has_many :categories
  has_many :ingredients
  has_many :recipes
end
