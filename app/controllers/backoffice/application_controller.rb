module Backoffice
  class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Basic::ControllerMethods

    before_action :htauth

    respond_to :json

    private

    def htauth(name = ENV['BACKOFFICE_HTAUTH_USERNAME'], password = ENV['BACKOFFICE_HTAUTH_PASSWORD'])
      authenticate_or_request_with_http_basic do |user_name, user_password|
        (user_name == name && user_password == password)
      end
    end
  end
end
