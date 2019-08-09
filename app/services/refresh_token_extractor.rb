class RefreshTokenExtractor
  HEADER_NAME = 'Authorization'.freeze

  attr_reader :headers

  def initialize(headers)
    @headers = headers
  end

  def call
    dec_token = JsonWebToken.decode(token)
    dec_token['type'] == 'REFRESH' ? User.find(dec_token[:user_id]) : nil
  end

  def token
    @token ||= headers[HEADER_NAME].split(' ').last if headers[HEADER_NAME]
  end
end
