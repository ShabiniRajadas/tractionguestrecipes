require 'rails_helper'

RSpec.describe SubRecipe do
  describe 'validations' do
    let(:sub_recipe) { FactoryBot.create(:sub_recipe) }

    it 'validates name' do
      sub_recipe.name = ''
      sub_recipe.unit_price = ''
      expect(sub_recipe).to_not be_valid
      expect(sub_recipe.errors[:name]).to eq ["can't be blank"]
    end
  end
end
