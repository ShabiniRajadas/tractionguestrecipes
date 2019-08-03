module Api
  module V1
    class CategoriesController < ::Api::ApplicationController
      include JsonResponseHelper
      before_action :authorize_request, except: :index

      def index
        categories = Category.where(company_id: company.id)
        show_response(categories, serializer, action_name)
      end

      def create
        category = Category.new(permitted_params)
        category.company = company
        category.uid = SecureRandom.uuid
        result = category.save ? category : error_response(category.errors)
        show_response(result, serializer, action_name)
      end

      def show
        show_response(category, serializer, 'show')
      end

      def update
        category.assign_attributes(permitted_params)
        updated_category = category.save ? category.reload : category.errors
        show_response(updated_category, serializer, action_name)
      end

      def destroy
        category.destroy
        head :no_content
      end

      private

      def serializer
        ::Api::V1::CategorySerializer
      end

      def permitted_params
        params.require(:data)
              .require(:attributes)
              .permit(:name,
                      :description)
      end

      def category
        @category ||= ::Category.find_by(id: params[:id])
      end

      def load_category
        return company_not_found unless company
      end

      def category_not_found
        errors.add(:category, 'not found')
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
