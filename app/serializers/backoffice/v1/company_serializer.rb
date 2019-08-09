module Backoffice
  module V1
    class CompanySerializer < ActiveModel::Serializer
      type 'company'
      attributes :id, :name, :uid, :description, :url
    end
  end
end
