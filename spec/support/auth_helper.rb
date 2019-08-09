module AuthHelper
  def http_login
    user = ENV['BACKOFFICE_HTAUTH_USERNAME']
    password = ENV['BACKOFFICE_HTAUTH_PASSWORD']
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, password)
  end

  def token_generator(user_id, exp)
    exp = exp.to_i
    JWT.encode({ user_id: user_id, exp: exp }, Rails.application.credentials.dig(:secret_key_base))
  end
end
