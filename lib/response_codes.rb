module ResponseCodes
  def self.ok
    "200 OK"
  end

  def self.moved
    "301 Moved Permanently"
  end

  def self.found
    "302 Found"
  end

  def self.unauthorized
    "401 Unauthorized"
  end

  def self.forbidden
    "403 Forbidden"
  end

  def self.not_found
    "404 Not Found"
  end

  def self.internal_server_error
    "500 Internal Server Error"
  end
end
