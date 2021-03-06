require './test/test_helper'
require './lib/server'

class ServerTest < Minitest::Test
  def test_it_gets_a_request
    assert Faraday.get "http://127.0.0.1:9292"
  end

  def test_server_exists
    @server = Server.new
    assert @server
  end

  def test_it_generates_a_diagnostic_response
    response = Faraday.get "http://127.0.0.1:9292"
    responses = response.body.split("\n")
    expected_responses = [\
      "<pre>",\
      "Verb: GET",\
      "Path: /",\
      "Protocol: HTTP/1.1",\
      "Host: 127.0.0.1:9292",\
      "Origin: 127.0.0.1",\
      "Accept: */*",\
      "</pre>"]
    assert_equal expected_responses, responses
  end
end
