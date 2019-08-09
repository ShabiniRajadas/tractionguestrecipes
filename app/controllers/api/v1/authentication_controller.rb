module Api
  module V1
    class AuthenticationController < ::Api::ApplicationController
      before_action :authorize_request, except: [:login, :reset_password]

      # POST /auth/login
      def login
        @user = User.find_by_email(params[:email])
        if @user&.authenticate(params[:password])
          token_generation(@user)
        else
          render json: { error: 'unauthorized' }, status: :unauthorized
        end
      end

      def reset_password
        @user = User.find_by_email(params[:email])
        if @user&.authenticate(params[:old_password])
          @user.update(password: params[:new_password])
          token_generation(@user)
        else
          render json: { error: 'User unavailable' }, status: :unauthorized
        end
      end

      def logout
        if @current_user
          token_blacklisted
          render json: { status: :ok }
        else
          render json: { error: 'unauthorized' }, status: :unauthorized
        end
      end

      private

      def login_params
        params.permit(:email, :password)
      end

      def token_generation(user)
        time = Time.now + 2.hours.to_i
        payload = { user_id: user.id }
        token = JsonWebToken.encode(payload, time)

        render json: { token: token, exp: time.strftime('%m-%d-%Y %H:%M'),
                       username: user.name }, status: :ok
      end

      def token_blacklisted
        if request.headers['Authorization']
          ::JwtBlacklist.create(blacklisted_token: token)
        end
        true
      end

      def token
        request.headers['Authorization'].split(' ').last
      end
    end
  end
end
