module Backoffice
  module V1
    class UsersController < ::Backoffice::ApplicationController
      respond_to :json, :jsonapi

      def index
        users = User.all
        show_response(users, serializer, action_name)
      end

      private

      def serializer
        ::Backoffice::V1::UserSerializer
      end
    end
  end
end
