module AuthHelper
  module_function

  def http_login
    user = ENV['BACKOFFICE_HTAUTH_USERNAME']
    password = ENV['BACKOFFICE_HTAUTH_PASSWORD']
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, password)
    end
end
