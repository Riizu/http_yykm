require './test/test_helper'
require './lib/server'
require './lib/game'

class GameTest < Minitest::Test
  def setup
    @conn = Faraday.new(:url => "http://127.0.0.1:9292")
  end

  def test_it_gets_a_request
    assert @conn
  end

  def test_game_can_be_started
    response = @conn.post do |req|
      req.url '/start_game'
    end
    assert response.body.include?("Good Luck!")
  end

  def test_guess_causes_redirect
    response = @conn.post do |req|
      req.url '/game'
      req.body = "10"
    end
    assert response.headers.include?("Location")
  end

  def test_guess_is_stored
    response = @conn.get 'game'
    assert response.body.include?("current guess")
  end

  def test_if_game_already_started
    @conn.post do |req|
      req.url '/start_game'
    end
    response = @conn.post do |req|
      req.url '/start_game'
    end
    assert 403, response.status
  end
end
