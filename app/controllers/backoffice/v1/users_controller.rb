module Backoffice
  module V1
    class UsersController < ::Backoffice::ApplicationController
      respond_to :json, :jsonapi
    end
  end
end
