module Api
  module V1
    class AuthenticationController < ::Api::ApplicationController
      before_action :authorize_request, only: %i[logout]

      # POST /auth/login
      def login
        @user = User.find_by_email(params[:email])
        if @user&.authenticate(params[:password])
          generate_tokens(@user)
        else
          render json: { error: 'unauthorized' }, status: :unauthorized
        end
      end

      def reset_password
        @user = User.find_by_email(params[:email])
        if @user&.authenticate(params[:old_password])
          @user.update(password: params[:new_password])
          render json: { message: 'User Password updated' }, status: :ok
        else
          render json: { error: 'User unavailable' }, status: :unauthorized
        end
      end

      def renew_token
        @current_user = RefreshTokenExtractor.new(request.headers).call
        if @current_user
          token = token_generation(@current_user)
          render json: { token: token[:token],
                         token_exp: formated_time(token[:time]),
                         username: @current_user.name }, status: :ok
        else
          render json: { error: 'unauthorized' }, status: :unauthorized
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
        payload = { user_id: user.id, type: 'TOKEN' }
        { token: JsonWebToken.encode(payload, time), time: time }
      end

      def refresh_token_generation(user)
        time = Time.now + 24.hours.to_i
        payload = { user_id: user.id, type: 'REFRESH' }
        { token: JsonWebToken.encode(payload, time), time: time }
      end

      def generate_tokens(user)
        token = token_generation(user)
        ref_token = refresh_token_generation(user)

        render json: { token: token[:token],
                       refresh_token: ref_token[:token],
                       token_exp: formated_time(token[:time]),
                       refresh_token_exp: formated_time(ref_token[:time]),
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

      def formated_time(time)
        time.strftime('%m-%d-%Y %H:%M')
      end
    end
  end
end
