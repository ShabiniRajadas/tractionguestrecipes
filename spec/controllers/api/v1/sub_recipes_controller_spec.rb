require 'rails_helper'

RSpec.describe Api::V1::SubRecipesController do
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
    let(:sub_recipe) { FactoryBot.create(:sub_recipe, company_id: company.id) }
    let(:do_request) { get(:index) }
    let(:expected_body) do
      [serialize_as_json(sub_recipe, serializer_class: Api::V1::SubRecipeSerializer)].to_json
    end

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end
  end

  describe '#create' do
    let(:sub_recipe_params) do
      {
        data: {
          type: 'sub_recipe',
          attributes: {
            name: 'Tomato sauce',
            description: 'Sauce for burgers',
            unit_price: 5.0,
            measurement_unit: 'grams'
          }
        }
      }
    end
    let(:do_request) { post(:create, params: sub_recipe_params) }

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end

    it 'responds with sub_recipe' do
      do_request
      expect(json_response_body).to eq(
        'data' => {
          'attributes' => {
            'name' => 'Tomato sauce',
            'description' => 'Sauce for burgers',
            'company_uid' => company.uid,
            'measurement_unit' => 'grams',
            'unit_price' => 5,
            'uid' => json_response_body['data']['attributes']['uid']
          },
          'id' => json_response_body['data']['id'],
          'type' => 'sub_recipe'
        }
      )
    end
  end
end
