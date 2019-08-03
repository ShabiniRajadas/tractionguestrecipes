module Api
  module V1
    class CategoriesController < ::Api::ApplicationController
      include ResponseHelper
      before_action :authorize_request, except: :index

      def index
        categories = Category.all
        show_response(categories, serializer, action_name)
      end

      private

      def serializer
        ::Api::V1::CategorySerializer
      end
    end
  end
end
