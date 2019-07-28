module Backoffice
  class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Basic::ControllerMethods

    before_action :htauth

    respond_to :json

    STATUS_CODE_MAPPINGS = { 'error' => 400,
                             'created' => 201,
                             'success' => 200 }.freeze

    def status(resource, method_name = nil)
      if method_name == 'index'
        find_status(resource)
      elsif resource[:errors].present?
        STATUS_CODE_MAPPINGS['error']
      elsif method_name == 'create'
        STATUS_CODE_MAPPINGS['created']
      else
        STATUS_CODE_MAPPINGS['success']
      end
    end

    private

    def htauth(name = ENV['BACKOFFICE_HTAUTH_USERNAME'], password = ENV['BACKOFFICE_HTAUTH_PASSWORD'])
      authenticate_or_request_with_http_basic do |user_name, user_password|
        (user_name == name && user_password == password)
      end
    end

    def find_status(resource)
      resource.class == Hash && resource[:errors].present? ? STATUS_CODE_MAPPINGS['error'] : STATUS_CODE_MAPPINGS['created']
    end
  end
end
