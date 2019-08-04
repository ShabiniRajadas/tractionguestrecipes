require 'rails_helper'

RSpec.describe Api::V1::IngredientsController do
  let(:company) { FactoryBot.create(:company) }
  let(:user) { FactoryBot.create(:user, company_id: company.id) }

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

  let(:headers) do
    {
      'Authorization' => token_generator(user.id, Time.now + 2.hours.to_i),
      'COMPANY' => company.uid
    }
  end

  before do
    headers.each { |k, v| request.headers[k] = v }
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
            measurement_unit: 'grams'
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
            'measurement_unit' => 'grams',
            'unit_price' => 10.0
          },
          'id' => json_response_body['data']['id'],
          'type' => 'ingredient'
        }
      )
    end
  end

  describe '#show' do
    let(:ingredient) { FactoryBot.create(:ingredient, company: company) }
    let(:do_request) { get(:show, params: { id: ingredient.id }) }
    let(:expected_body) { serialize_as_json(ingredient, serializer_class: Api::V1::IngredientSerializer).stringify_keys }

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end

    it 'responds with ingredient' do
      do_request
      expect(json_response_body).to eq(
        'data' =>
          {
            'id' => ingredient.id.to_s,
            'type' => 'ingredient',
            'attributes' => expected_body.except!('id')
          }
      )
    end
  end

  describe '#update' do
    let(:ingredient) { FactoryBot.create(:ingredient, company: company) }
    let(:ingredient_params) do
      {
        id: ingredient.id,
        data: {
          type: 'ingredient',
          attributes: {
            name: 'Chilly Powder',
            description: 'testing',
            measurement_unit: 'grams'
          }
        }
      }
    end
    let(:do_request) { put(:update, params: ingredient_params) }

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end

    it 'responds with ingredient' do
      do_request
      expect(json_response_body).to eq(
        'data' => {
          'attributes' => {
            'name' => 'Chilly Powder',
            'description' => 'testing',
            'company_uid' => company.uid,
            'measurement_unit' => 'grams',
            'unit_price' => 10.0
          },
          'id' => json_response_body['data']['id'],
          'type' => 'ingredient'
        }
      )
    end
  end

  describe 'DELETE #delete' do
    let(:ingredient) { FactoryBot.create(:ingredient, company: company) }
    let(:destroy_params) do
      {
        id: ingredient.id
      }
    end

    let(:do_request) { delete :destroy, params: destroy_params, format: :jsonapi }

    it 'responds with status' do
      do_request
      expect(response).to be_successful
      expect(response.status).to eq(204)
    end
  end
end
