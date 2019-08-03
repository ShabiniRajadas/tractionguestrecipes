require 'rails_helper'

RSpec.describe Category do
  describe 'validations' do
    let(:category) { FactoryBot.create(:category) }

    it 'validates name' do
      category.name = ''
      expect(category).to_not be_valid
      expect(category.errors[:name]).to eq ["can't be blank"]
    end
  end
end
