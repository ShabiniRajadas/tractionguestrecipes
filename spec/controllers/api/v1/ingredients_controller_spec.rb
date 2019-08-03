require 'rails_helper'

RSpec.describe Api::V1::IngredientsController do
  let(:company) { FactoryBot.create(:company) }
  let(:user) { FactoryBot.create(:user, company_id: company.id) }

  let(:headers) do
    {
      'Authorization' => token_generator(user.id, Time.now + 2.hours.to_i),
      'COMPANY' => company.uid
    }
  end

  before do
    headers.each { |k, v| request.headers[k] = v }
  end

  describe '#index' do
    let(:ingredient) { FactoryBot.create(:ingredient, company_id: company.id) }
    let(:do_request) { get(:index) }
    let(:expected_body) do
      [serialize_as_json(ingredient, serializer_class: Api::V1::IngredientSerializer)].to_json
    end

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end
  end

  describe '#create' do
    let(:ingredient_params) do
      {
        data: {
          type: 'ingredient',
          attributes: {
            name: 'test',
            description: 'starters',
            unit_price: 10.0,
            measurement_unit: 1
          }
        }
      }
    end
    let(:do_request) { post(:create, params: ingredient_params) }

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end

    it 'responds with ingredient' do
      do_request
      expect(json_response_body).to eq(
        'data' => {
          'attributes' => {
            'name' => 'test',
            'description' => 'starters',
            'company_uid' => company.uid,
            'measurement_unit' => 1,
            'unit_price' => 10.0
          },
          'id' => json_response_body['data']['id'],
          'type' => 'ingredient'
        }
      )
    end
  end
end
