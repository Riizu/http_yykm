class ServerTest < Minitest::Test
  def setup
    @server = Server.new
  end

  def test_server_can_run
    @server.start
  end

end


