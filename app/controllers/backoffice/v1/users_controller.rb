module Backoffice
  module V1
    class UsersController < ::Backoffice::ApplicationController
      include ActiveModel::Validations
      respond_to :json, :jsonapi
      before_action :load_user, only: %i[destroy]

      def index
        users = User.all
        show_response(users, serializer, action_name)
      end

      def create
        user = User.new(permitted_params)
        user.company = company
        new_user = user.save ? user : error_response(user.errors)
        show_response(new_user, serializer, action_name)
      end

      def destroy
        user.destroy
        head :no_content
      end

      private

      def permitted_params
        params.require(:data)
              .require(:attributes)
              .permit(:email,
                      :password,
                      :password_confirmation)
      end

      def serializer
        ::Backoffice::V1::UserSerializer
      end

      def user
        @user ||= User.find(params[:id])
      end

      def load_user
        return user_not_found unless user
      end

      def user_not_found
        errors.add(:user, 'not found')
        resource = error_serializer.serialize(errors)
        render json: resource,
               each_serializer: serializer,
               adapter: :json_api,
               key_transform: :underscore,
               status: status(resource)
      end
    end
  end
end
