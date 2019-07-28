require 'rails_helper'

RSpec.describe Company do
  describe 'validations' do
    let(:company) { FactoryBot.create(:company_record) }

    it 'validates name' do
      company.name = ''
      expect(company).to_not be_valid
      expect(company.errors[:name]).to eq ["can't be blank"]
    end
  end
end
