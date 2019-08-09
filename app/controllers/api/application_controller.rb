module Api
  class ApplicationController < ActionController::API
    include JsonResponseHelper

    def not_found
      render json: { error: 'not_found' }
    end

    def authorize_request
      return not_valid_token if blacklisted_token.present?

      @current_user = TokenExtractor.new(request.headers).call
      return not_found if @current_user.nil?

      @current_user
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end

    private

    def blacklisted_token
      ::JwtBlacklist.find_by(blacklisted_token: bearer_token)
    end

    def bearer_token
      request.headers['Authorization'].split(' ').last
    end
  end
end
