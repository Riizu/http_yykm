require './lib/output_view'
require './lib/game'
require './lib/response_codes'
require 'pp'

class Router

  include ResponseCodes

  def initialize
    @output_view = OutputView.new
    @game = Game.new
    @num_routes = 0
  end

  def route(client, parsed_request)
    @num_routes += 1

    # DEBUG:
    puts "Number of requests: #{@num_routes}"
    pp parsed_request
    print "\n"  

    case parsed_request["Path"]
    when "/"
      @output_view.generate_diagnostic_response(client, parsed_request)
    when "/hello"
      @output_view.generate_hello_response(client)
    when "/datetime"
      @output_view.generate_datetime_response(client)
    when "/shutdown"
      @output_view.shutdown(client, @num_routes)
    when "/word_search"
      @output_view.generate_word_search_response(client, parsed_request)
    when "/parsed_request"
      client.puts parsed_request
    when "/start_game"
      @game.start_game(client, parsed_request)
    when "/game"
      @game.game(client, parsed_request)
    else
      @output_view.error(client, "404 not found", ResponseCodes.not_found)
    end

  end
end
