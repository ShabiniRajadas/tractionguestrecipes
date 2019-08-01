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

    def error_serializer
      ::Backoffice::V1::ErrorSerializer
    end

    def show_response(resource, serializer, method_name = nil)
      render json: resource,
             each_serializer: serializer,
             adapter: :json_api,
             key_transform: :underscore,
             status: status(resource, method_name)
    end

    def error_response(errors)
      error_serializer.serialize(errors)
    end

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

    def find_status(resource)
      resource.class == Hash && resource[:errors].present? ? error : created
    end

    def error
      STATUS_CODE_MAPPINGS['error']
    end

    def created
      STATUS_CODE_MAPPINGS['created']
    end
  end
end
