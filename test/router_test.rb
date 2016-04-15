require './test/test_helper'
require './lib/router'

class RouterTest < Minitest::Test

  def setup
    @router = Router.new
    @client = Client.new
  end

  def test_router_exists
    assert @router
  end

  def test_valid_routes
    assert @router.route(@client, {"Path"=>"/hello"}).include?("Hello, World")
    assert @router.route(@client, {"Path"=>"/datetime"}).include?("2016")
    assert @router.route(@client, {"Path"=>"/force_error"}).include?("sys_error")
  end

  def test_invalid_routes
    assert @router.route(@client, {"Path"=>"/asdsadfas"}).include?("404")
  end

end

class Client
  def puts(stuff)
    return stuff
  end
end
