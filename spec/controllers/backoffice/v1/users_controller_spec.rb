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
end
