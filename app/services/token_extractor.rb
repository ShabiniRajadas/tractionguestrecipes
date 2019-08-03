class TokenExtractor
  HEADER_NAME = 'Authorization'.freeze

  attr_reader :headers

  def initialize(headers)
    @headers = headers
  end

  def call
    decoded_token = JsonWebToken.decode(token)
    User.find(decoded_token[:user_id])
  end

  def token
    @token ||= headers[HEADER_NAME].split(' ').last if headers[HEADER_NAME]
  end
end
