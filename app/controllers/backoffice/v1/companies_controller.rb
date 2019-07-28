module Backoffice
  module V1
    class CompaniesController < ::Backoffice::ApplicationController
    	def index
    		companies = Company.all
    		show_response(companies, 'index')
    	end

    	def create
    	end

    	def show
    	end

    	def update
    	end

    	def destroy
    	end

    	private

    	def permitted_params
    		params.require(:data).require(:attributes).require(:name, :description, :url, :image)
    	end

    	def serializer
        	::Backoffice::V1::CompanySerializer
      	end

      	def show_response(query, method_name = nil)
        	resource = query
        	render json: resource, each_serializer: serializer, adapter: :json_api, key_transform: :underscore, status: status(resource, method_name)
      	end
    end
  end
end
