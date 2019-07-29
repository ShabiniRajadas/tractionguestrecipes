module AuthHelper
  def http_login
    user = ENV['BACKOFFICE_HTAUTH_USERNAME']
    password = ENV['BACKOFFICE_HTAUTH_PASSWORD']
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, password)
  end

  def json_response_body
    JSON.parse response.body
  end
end
