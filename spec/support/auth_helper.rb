module AuthHelper
  def http_login
    user = ENV['BACKOFFICE_HTAUTH_USERNAME']
    password = ENV['BACKOFFICE_HTAUTH_PASSWORD']
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, password)
  end

  def token_generator(_user_id, exp)
    exp = exp.to_i
    payload = { user_id: user.id, type: 'TOKEN', exp: exp }
    JWT.encode(payload, Rails.application.credentials.dig(:secret_key_base))
  end
end
