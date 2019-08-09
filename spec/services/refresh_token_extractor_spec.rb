require 'rails_helper'

describe RefreshTokenExtractor do
  describe '#call' do
    subject(:extract_token) { described_class.new(headers).call }

    let(:user) { FactoryBot.create(:user) }

    let(:token) do
      JWT.encode({ user_id: user.id, type: 'REFRESH',
                   exp: (Time.now + 2.hours.to_i).to_i },
                 Rails.application.credentials.dig(:secret_key_base))
    end

    context 'when partner present' do
      context 'when header present' do
        let(:headers) { { 'Authorization' => token } }

        it 'finds user' do
          expect(extract_token).to eq user
        end
      end
    end
  end
end
