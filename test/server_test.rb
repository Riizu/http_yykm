require './test/test_helper'
require './lib/server'

class ServerTest < Minitest::Test
  def setup
    @server = Server.new
  end

  def test_it_exists
    assert @server
  end

end
