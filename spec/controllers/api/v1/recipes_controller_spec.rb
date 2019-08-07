require 'rails_helper'

RSpec.describe Api::V1::RecipesController do
  let(:company) { FactoryBot.create(:company) }
  let(:user) { FactoryBot.create(:user, company_id: company.id) }
  let(:category) { FactoryBot.create(:category, company_id: company.id, uid: '815265183490498172846187') }

  describe '#index' do
    let(:recipe) { FactoryBot.create(:recipe, company_id: company.id, category_id: category.id) }
    let(:do_request) { get(:index) }
    let(:expected_body) do
      [serialize_as_json(recipe, serializer_class: Api::V1::RecipeSerializer)].to_json
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
    let(:ingredient) { FactoryBot.create(:ingredient, company: company, uid: '8567569879458798765') }
    let(:recipe_params) do
      {
        data: {
          type: 'recipe',
          attributes: {
            name: 'Tomato sauce',
            description: 'Sauce for burgers',
            unit_price: 5.0,
            measurement_unit: 'grams',
            category_id: category.uid,
            ingredients: [
              {
                uid: ingredient.uid,
                quantity: 1
              }
            ]
          }
        }
      }
    end
    let(:do_request) { post(:create, params: recipe_params) }

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end

    it 'responds with recipe' do
      do_request
      expect(json_response_body).to eq(
        'data' => {
          'attributes' => {
            'name' => 'Tomato sauce',
            'description' => 'Sauce for burgers',
            'company_uid' => company.uid,
            'measurement_unit' => 'grams',
            'unit_price' => 5,
            'uid' => json_response_body['data']['attributes']['uid'],
            'ingredient_names' => ingredient.name,
            'category_uid' => category.uid
          },
          'id' => json_response_body['data']['id'],
          'type' => 'recipe'
        }
      )
    end
  end

  describe '#show' do
    let(:recipe) { FactoryBot.create(:recipe, company: company, category: category) }
    let(:do_request) { get(:show, params: { id: recipe.id }) }
    let(:expected_body) { serialize_as_json(recipe, serializer_class: Api::V1::RecipeSerializer).stringify_keys }

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end

    it 'responds with recipe' do
      do_request
      expect(json_response_body).to eq(
        'data' =>
          {
            'id' => recipe.id.to_s,
            'type' => 'recipe',
            'attributes' => expected_body.except!('id')
          }
      )
    end
  end

  describe '#update' do
    let(:recipe) { FactoryBot.create(:recipe, company: company, category: category) }
    let(:recipe_params) do
      {
        id: recipe.id,
        data: {
          type: 'recipe',
          attributes: {
            name: 'Bread',
            description: 'Used for burgers',
            measurement_unit: 'count'
          }
        }
      }
    end
    let(:do_request) { put(:update, params: recipe_params) }

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end

    it 'responds with recipe' do
      do_request
      expect(json_response_body).to eq(
        'data' => {
          'attributes' => {
            'name' => 'Bread',
            'description' => 'Used for burgers',
            'company_uid' => company.uid,
            'measurement_unit' => 'count',
            'uid' => json_response_body['data']['attributes']['uid'],
            'ingredient_names' => recipe.ingredients.pluck(:name).join(', '),
            'unit_price' => 10.0,
            'category_uid' => category.uid
          },
          'id' => json_response_body['data']['id'],
          'type' => 'recipe'
        }
      )
    end
  end

  describe 'DELETE #delete' do
    let(:recipe) { FactoryBot.create(:recipe, company: company, category: category) }
    let(:destroy_params) do
      {
        id: recipe.id
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
