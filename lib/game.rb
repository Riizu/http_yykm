require './lib/response_codes'
require './lib/output_view'

class Game

include ResponseCodes

  def initialize
    @guesses = 0
    @current_guess = nil
    @secret_number = rand(100)
  end

  def start_game(client, parsed_request)
    case parsed_request["Verb"]
    when "POST"
      client.puts "Welcome to Guess the Number!\n"\
                  "Please guess a number between 0 and 100\n"\
                  "Good Luck"
      client.puts "DEBUG: Secret_number is #{@secret_number}"
    else ResponseCodes.not_found
    end
  end

  def read_guess(client, parsed_request)
    guess = client.read(parsed_request["Content-Length"].to_i)
  end

  def game(client, parsed_request)
    @guesses += 1
    case parsed_request["Verb"]
    when "GET"
      get_response(client, parsed_request)
    when "POST"
        @current_guess = read_guess(client, parsed_request).to_i
        puts "This is current guess: #{@current_guess}"
        post_response(client, parsed_request)
    else ResponseCodes.not_found
    end
  end

  def get_response(client, parsed_request)
    client.puts "http/1.1 #{ResponseCodes.ok}\n\r"
    client.puts "You've guessed #{@guesses} times"
    client.puts "Invalid Guess: #{invalid_guess?}"
    client.puts check_guess
  end

  def post_response(client, parsed_request)
    client.puts generate_redirect_header
    # client.puts "Sending Reponse!"
  end

  def generate_redirect_header
    "http/1.1 #{ResponseCodes.redirect}\n"\
    "Location: http://127.0.0.1:9292/game\n\r\n\r"
  end

  def invalid_guess?
    @current_guess.nil? || @current_guess > 100 || @current_guess < 0
  end

  def check_guess
    if invalid_guess?
      response = "Please guess a number between 0 and 100"
    elsif @current_guess == @secret_number
      response = "You guesses the number! It was #{@secret_number}"
    elsif @current_guess > @secret_number
      response = "Your guess was too high"
    elsif @current_guess < @secret_number
      response = "Your guess was too low"
    else
    end
     "this is your current guess: #{@current_guess}" + "\n" + response
  end
end
