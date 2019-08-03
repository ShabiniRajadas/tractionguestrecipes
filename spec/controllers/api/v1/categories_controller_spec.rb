require 'rails_helper'

RSpec.describe Api::V1::CategoriesController do
  describe '#index' do
    let(:company) { FactoryBot.create(:company_record) }
    let(:user) { FactoryBot.create(:user, company_id: company.id) }

    let(:category) { FactoryBot.create(:category_record) }
    let(:do_request) { get(:index) }
    let(:expected_body) do
      [serialize_as_json(category, serializer_class: Api::V1::CategorySerializer)].to_json
    end

    let(:headers) do
      {
        'Authorization' => token_generator(user.id, Time.now + 2.hours.to_i),
        'COMPANY' => company.uid
      }
    end

    before do
      headers.each { |k, v| request.headers[k] = v }
    end

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end
  end

  describe '#create' do
    let(:company) { FactoryBot.create(:company_record) }
    let(:category_params) do
      {
        data: {
          type: 'category',
          attributes: {
            name: 'test',
            description: 'starters'
          }
        }
      }
    end
    let(:do_request) { post(:create, params: category_params) }

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
            'description' => 'starters',
            'company_uid' => company.uid
          },
          'id' => json_response_body['data']['id'],
          'type' => 'category'
        }
      )
    end
  end
end
