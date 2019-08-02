require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController do
  describe '#login' do
    let(:user) { FactoryBot.create(:user) }
    let(:do_request) { post(:login, params: {email: user.email, password: user.password}) }


    it 'responds with success' do
      do_request
      expect(response).to be_successful
    end

    it "responds with a token" do
      do_request
      expect(json_response_body["token"]).not_to be_empty
      expect(json_response_body["exp"]).not_to be_empty
      expect(json_response_body["user_name"]).to eq(user.name)
    end
  end
end