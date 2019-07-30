require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    let(:user) { FactoryBot.create(:user) }

    it 'validates name' do
      user.email = ''
      expect(user).to_not be_valid
      expect(user.errors[:email]).to eq ["can't be blank"]
    end
  end
end
