module Backoffice
  module V1
    module ErrorSerializer
      def self.serialize(errors)
        return if errors.nil?

        result = {}
        new_hash = errors.to_hash(true).map do |key, value|
          value.map do |msg|
            { title: key, code: key, details: msg }
          end
        end
        new_hash = new_hash.flatten
        result[:errors] = new_hash
        result
      end
    end
  end
end
