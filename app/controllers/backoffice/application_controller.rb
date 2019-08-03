module Backoffice
  class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Basic::ControllerMethods
    include ResponseHelper
    before_action :htauth

    respond_to :json

    private

    def htauth(name = http_username, password = http_password)
      authenticate_or_request_with_http_basic do |user_name, user_password|
        (user_name == name && user_password == password)
      end
    end

    def http_username
      ENV['BACKOFFICE_HTAUTH_USERNAME']
    end

    def http_password
      ENV['BACKOFFICE_HTAUTH_PASSWORD']
    end
  end
end
