module Backoffice
  module V1
    class UsersController < ::Backoffice::ApplicationController
      respond_to :json, :jsonapi

      def index
        users = User.all
        show_response(users, serializer, action_name)
      end

      def create
        user = User.new(permitted_params)
        new_user = user.save ? user : error_response(user.errors)
        show_response(new_user, serializer, action_name)
      end

      private

      def permitted_params
        params.require(:data).require(:attributes).permit(:email)
      end

      def serializer
        ::Backoffice::V1::UserSerializer
      end
    end
  end
end
