require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController do
  describe '#login' do
    let(:user) { FactoryBot.create(:user) }
    let(:do_request) do
      post(:login,
           params: { email: user.email,
                     password: user.password })
    end

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end

    it 'responds with a token' do
      do_request
      expect(json_response_body['token']).not_to be_empty
      expect(json_response_body['refresh_token']).not_to be_empty
      expect(json_response_body['user_name']).to eq(user.name)
    end
  end

  describe '#reset_password' do
    let(:company) { FactoryBot.create(:company) }
    let(:user) { FactoryBot.create(:user, company: company) }

    let(:do_request) do
      post(:reset_password,
           params: { email: user.email,
                     old_password: user.password,
                     new_password: 'test_password' })
    end

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end

    it 'responds with a token' do
      do_request
      expect(json_response_body['message']).not_to be_empty
    end
  end

  describe '#logout' do
    let(:company) { FactoryBot.create(:company) }
    let(:user) { FactoryBot.create(:user, company: company) }
    let(:headers) do
      {
        'Authorization' => "Bearer #{token_generator(user.id, Time.now + 2.hours.to_i)}",
        'COMPANY' => company.uid
      }
    end

    before do
      headers.each { |k, v| request.headers[k] = v }
    end

    let(:do_request) do
      delete(:logout)
    end

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end

    it 'responds with a token' do
      do_request
      expect(json_response_body['status']).to eq('ok')
    end
  end
end
