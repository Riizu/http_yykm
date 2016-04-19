require './test/test_helper'
require './lib/server'
require './lib/game'

class GameUnitTest < Minitest::Test
  def setup
    @game = Game.new
  end

  def test_if_game_starts
    @game.start_game($stdout, parsed_request)
    assert @game.running
  end

  def parsed_request
    {"Verb"=>"POST","Path"=>"/start_game","Protocol"=>"HTTP/1.1",\
    "User-Agent"=>"Faraday v0.9.2","Content-Length"=>"0",\
    "Accept-Encoding"=>"gzip;q=1.0,deflate;q=0.6,identity;q=0.3",\
    "Accept"=>"*/*","Connection"=>"close","Host"=>"127.0.0.1:9292",\
    "Content-Type"=>"application/x-www-form-urlencoded"}
  end
end
