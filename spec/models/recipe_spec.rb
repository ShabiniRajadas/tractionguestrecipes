require 'rails_helper'

RSpec.describe Recipe do
  describe 'validations' do
    let(:category) { FactoryBot.create(:category) }
    let(:recipe) { FactoryBot.create(:recipe, category: category) }

    it 'validates name' do
      recipe.name = ''
      recipe.unit_price = ''
      expect(recipe).to_not be_valid
      expect(recipe.errors[:name]).to eq ["can't be blank"]
    end
  end
end
