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
end
