require './test/test_helper'
require './lib/output_view'

class OutputViewTest < Minitest::Test

  def setup
    @output = OutputView.new
    @client = Client.new
  end

  def test_if_output_view_exists
    assert @output
  end

  def test_hello_response
    assert @output.generate_hello_response(@client).include?("Hello")
  end

  def test_datetime_response
    assert @output.generate_datetime_response(@client).include?("2016")
  end

  def test_get_words
    assert @output.get_words.include?("alphabet")
  end

  def test_word_search_response
    assert @output.generate_word_search_response(@client, {"Params" => {"word"=>"hello"}})
  end


  def test_error_response
    assert @output.error(@client, "Example response", "404").include?("Example")
  end

end

class Client
  def puts(stuff)
    return stuff
  end
end
