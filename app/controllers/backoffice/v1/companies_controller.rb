module Backoffice
  module V1
    class CompaniesController < ::Backoffice::ApplicationController
    	def index
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
    end
  end
end
