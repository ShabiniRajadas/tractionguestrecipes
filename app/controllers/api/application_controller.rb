module Api
  class ApplicationController < ActionController::API
    def not_found
      render json: { error: 'not_found' }
    end

    def authorize_request
      @current_user = TokenExtractor.new(request.headers).call
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
