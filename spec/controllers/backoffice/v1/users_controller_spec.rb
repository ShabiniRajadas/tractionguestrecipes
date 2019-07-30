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
    let(:user_params) do
      {
        data: {
          type: 'user',
          attributes: {
            email: 'sample@sample.com'
          }
        }
      }
    end
    let(:do_request) { post(:create, params: user_params) }

    before do
      http_login
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
            'email' => 'sample@sample.com'
          },
          'id' => json_response_body['data']['id'],
          'type' => 'user'
        }
      )
    end
  end
end
