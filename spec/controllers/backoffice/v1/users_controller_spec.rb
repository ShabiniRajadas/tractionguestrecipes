require 'rails_helper'

RSpec.describe Backoffice::V1::UsersController do
  describe '#index' do
    let(:user) { FactoryBot.create(:user) }
    let(:do_request) { get(:index) }
    let(:expected_body) do
      [serialize_as_json(user, serializer_class: Backoffice::V1::UserSerializer)].to_json
    end

    before do
      http_login
      user
    end

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end
  end

  describe '#create' do
    let(:company) { FactoryBot.create(:company_record) }
    let(:user_params) do
      {
        data: {
          type: 'user',
          attributes: {
            name: 'test',
            email: 'sample@sample.com',
            password: 'password'
          }
        }
      }
    end
    let(:do_request) { post(:create, params: user_params) }

    let(:headers) do
      {
        'Accept' => 'application/json',
        'COMPANY' => company.uid
      }
    end

    before do
      http_login
      headers.each { |k, v| request.headers[k] = v }
    end

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end

    it 'responds with companies' do
      do_request
      expect(json_response_body).to eq(
        'data' => {
          'attributes' => {
            'name' => 'test',
            'email' => 'sample@sample.com',
            'company_uid' => company.uid
          },
          'id' => json_response_body['data']['id'],
          'type' => 'user'
        }
      )
    end
  end

  describe 'destroy' do
    let(:user) { FactoryBot.create(:user) }
    let(:do_request) { delete :destroy, params: { id: user.id }, format: :json }

    before do
      http_login
      user
    end

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end
  end
end
