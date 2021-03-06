module Backoffice
  module V1
    class CompaniesController < ::Backoffice::ApplicationController
      include ActiveModel::Validations
      respond_to :json, :jsonapi
      before_action :load_company, except: %i[create index]

      def index
        companies = Company.all
        show_response(companies, serializer, action_name)
      end

      def create
        company = ::Company.new(permitted_params)
        company.uid = SecureRandom.uuid
        new_company = company.save ? company : error_response(company.errors)
        show_response(new_company, serializer, action_name)
      end

      def show
        show_response(company, serializer, 'show')
      end

      def update
        company.assign_attributes(permitted_params)
        updated_company = company.save ? company.reload : company.errors
        show_response(updated_company, serializer, action_name)
      end

      def destroy
        company.destroy
        head :no_content
      end

      private

      def permitted_params
        params.require(:data).require(:attributes).permit(:name,
                                                          :description,
                                                          :url,
                                                          :image)
      end

      def serializer
        ::Backoffice::V1::CompanySerializer
      end

      def company
        @company ||= ::Company.find_by(id: params[:id])
      end

      def load_company
        return company_not_found unless company
      end

      def company_not_found
        errors.add(:company, 'not found')
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
