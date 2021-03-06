class TokenExtractor
  HEADER_NAME = 'Authorization'.freeze

  attr_reader :headers

  def initialize(headers)
    @headers = headers
  end

  def call
    decoded_token = JsonWebToken.decode(token)
    decoded_token['type'] == 'TOKEN' ? User.find(decoded_token[:user_id]) : nil
  end

  def token
    @token ||= headers[HEADER_NAME].split(' ').last if headers[HEADER_NAME]
  end
end
