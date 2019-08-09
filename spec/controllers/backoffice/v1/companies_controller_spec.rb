require 'rails_helper'

RSpec.describe Backoffice::V1::CompaniesController do
  describe '#index' do
    let(:company) { FactoryBot.create(:company) }
    let(:do_request) { get(:index) }
    let(:expected_body) do
      [serialize_as_json(company, serializer_class: Backoffice::V1::CompanySerializer)].to_json
    end

    before do
      http_login
      company
    end

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end
  end

  describe '#show' do
    let(:company) { FactoryBot.create(:company) }
    let(:do_request) { get(:show, params: { id: company.id }) }
    let(:expected_body) { serialize_as_json(company, serializer_class: Backoffice::V1::CompanySerializer).stringify_keys }

    before do
      http_login
      company
    end

    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end

    it 'responds with companies' do
      do_request
      expect(json_response_body).to eq(
        'data' =>
          {
            'id' => company.id.to_s,
            'type' => 'company',
            'attributes' => expected_body.except!('id')
          }
      )
    end
  end

  describe '#create' do
    let(:company_params) do
      {
        data: {
          type: 'company',
          attributes: {
            name: 'company_name',
            url: 'testing.com',
            description: 'Testing'
          }
        }
      }
    end
    let(:do_request) { post(:create, params: company_params) }

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
            'uid' => json_response_body['data']['attributes']['uid'],
            'name' => 'company_name',
            'url' => 'testing.com',
            'description' => 'Testing'
          },
          'id' => json_response_body['data']['id'],
          'type' => 'company'
        }
      )
    end
  end

  describe '#update' do
    let(:company) { create(:company) }
    let(:company_params) do
      {
        id: company.id,
        data: {
          type: 'company',
          attributes: {
            name: 'newtest',
            description: 'testing',
            url: 'test.com'
          }
        }
      }
    end
    let(:do_request) { put(:update, params: company_params) }

    before do
      http_login
      company
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
            'uid' => json_response_body['data']['attributes']['uid'],
            'name' => 'newtest',
            'description' => 'testing',
            'url' => 'test.com'
          },
          'id' => json_response_body['data']['id'],
          'type' => 'company'
        }
      )
    end
  end

  describe 'DELETE #delete' do
    let(:company) { FactoryBot.create(:company) }
    let(:destroy_params) do
      {
        id: company.id
      }
    end

    let(:do_request) { delete :destroy, params: destroy_params, format: :jsonapi }

    before do
      http_login
    end

    it 'responds with status' do
      do_request
      expect(response).to be_successful
      expect(response.status).to eq(204)
    end
  end
end
