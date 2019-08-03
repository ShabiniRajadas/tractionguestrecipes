require 'rails_helper'

RSpec.describe Ingredient do
  describe 'validations' do
    let(:ingredient) { FactoryBot.create(:ingredient) }

    it 'validates name and unit_price' do
      ingredient.name = ''
      ingredient.unit_price = ''
      expect(ingredient).to_not be_valid
      expect(ingredient.errors[:name]).to eq ["can't be blank"]
    end
  end
end
