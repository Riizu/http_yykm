require './lib/response_codes'
require './lib/output_view'

class Game

include ResponseCodes

  def initialize
    @guesses = 0
    @current_guess
  end

  def start_game(client, parsed_request)
    case parsed_request["Verb"]
    when "POST" then client.puts "Good Luck"
    else ResponseCodes.not_found
    end
  end

  def read_guess(client, parsed_request)
    client.read(parsed_request["Content-Length"].to_i)
  end

  def game(client, parsed_request)
    @guesses += 1
    case parsed_request["Verb"]
    when "GET"
      get_response(client, parsed_request)
    when "POST"
      post_response(client, parsed_request)
    else ResponseCodes.not_found
    end
  end

  def get_response(client, parsed_request)
    client.puts "You've guessed #{@guesses} times"
    client.puts "Good Luck"
    client.puts "this is your current guess: #{@current_guess}"
  end

  def post_response(client, parsed_request)
    @current_guess = read_guess(client, parsed_request)
    ResponseCodes.found
    client.puts "Redirect not yet implemented"
  end
end
