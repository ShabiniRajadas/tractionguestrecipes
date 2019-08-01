class CompanyExtractor
  HEADER_NAME = 'COMPANY'.freeze

  attr_reader :headers

  def initialize(headers)
    @headers = headers
  end

  def call
    ::Company.find_by(uid: uid)
  end

  def uid
    @uid ||= headers[HEADER_NAME].to_s.downcase.strip
  end
end
