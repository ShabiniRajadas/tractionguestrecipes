class JsonWebToken
  class << self
    def encode(payload, exp)
      payload[:exp] = exp.to_i
      JWT.encode(payload, secret_key)
    end

    def decode(token)
      body = JWT.decode(token, secret_key)[0]
      HashWithIndifferentAccess.new body
    end

    def secret_key
      Rails.application.credentials.dig(:secret_key_base)
    end
  end
end
