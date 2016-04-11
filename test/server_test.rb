require './test/test_helper'
require './lib/server'

class ServerTest < Minitest::Test
  def test_it_exists
    server = Server.new

    assert server
  end
end
