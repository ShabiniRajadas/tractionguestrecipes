module ResponseHelper

    STATUS_CODE_MAPPINGS = { 'error' => 400,
                             'created' => 201,
                             'success' => 200 }.freeze

    def status(resource, method_name = nil)
      case method_name
      when 'index'
        find_status(resource)
      when 'create'
        STATUS_CODE_MAPPINGS['created']
      else
        return STATUS_CODE_MAPPINGS['error'] if resource[:errors].present?

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

    def company
      @company ||= ::CompanyExtractor.new(request.headers).call
    end

    private

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