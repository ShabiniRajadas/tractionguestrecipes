require 'rails_helper'

RSpec.describe Api::V1::CategoriesController do
  let(:company) { FactoryBot.create(:company) }
  let(:user) { FactoryBot.create(:user, company_id: company.id) }

  describe '#index' do
    let(:category) { FactoryBot.create(:category, company_id: company.id) }
    let(:do_request) { get(:index) }
    let(:expected_body) do
      [serialize_as_json(category, serializer_class: Api::V1::CategorySerializer)].to_json
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

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end

    it 'responds with category' do
      do_request
      expect(json_response_body).to eq(
        'data' => {
          'attributes' => {
            'name' => 'test',
            'description' => 'starters',
            'company_uid' => company.uid,
            'uid' => json_response_body['data']['attributes']['uid']
          },
          'id' => json_response_body['data']['id'],
          'type' => 'category'
        }
      )
    end
  end

  describe '#show' do
    let(:category) { FactoryBot.create(:category, company: company) }
    let(:do_request) { get(:show, params: { id: category.id }) }
    let(:expected_body) { serialize_as_json(category, serializer_class: Api::V1::CategorySerializer).stringify_keys }

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end

    it 'responds with category' do
      do_request
      expect(json_response_body).to eq(
        'data' =>
          {
            'id' => category.id.to_s,
            'type' => 'category',
            'attributes' => expected_body.except!('id')
          }
      )
    end
  end

  describe '#update' do
    let(:category) { FactoryBot.create(:category, company: company) }
    let(:category_params) do
      {
        id: category.id,
        data: {
          type: 'category',
          attributes: {
            name: 'newtest',
            description: 'testing'
          }
        }
      }
    end
    let(:do_request) { put(:update, params: category_params) }

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end

    it 'responds with category' do
      do_request
      expect(json_response_body).to eq(
        'data' => {
          'attributes' => {
            'name' => 'newtest',
            'description' => 'testing',
            'company_uid' => company.uid,
            'uid' => json_response_body['data']['attributes']['uid']
          },
          'id' => json_response_body['data']['id'],
          'type' => 'category'
        }
      )
    end
  end

  describe 'DELETE #delete' do
    let(:category) { FactoryBot.create(:category, company: company) }
    let(:destroy_params) do
      {
        id: category.id
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
