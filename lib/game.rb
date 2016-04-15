require './lib/response_codes'
require './lib/output_view'

class Game

include ResponseCodes

  attr_reader :running

  def initialize
    @guesses = 0
    @current_guess = nil
    @secret_number = rand(100)
    @running = false
  end

  def start_game(client, parsed_request)
    if is_game_started?
      client.puts "http/1.1 #{ResponseCodes.forbidden}\n\r"
      client.puts "Welcome to Guess the Number!\n"
      client.puts "Game Already started!\n"
    else
      @running = true
    end

    case parsed_request["Verb"]
    when "POST"
      client.puts "http/1.1 #{ResponseCodes.moved}\r\n\r\n"
      client.puts "Welcome to Guess the Number!\n"\
                  "Please guess a number between 0 and 100\n"\
                  "Good Luck"
    else
      client.puts "http/1.1 #{ResponseCodes.not_found}\n\r"
    end
  end

  def is_game_started?
    @running
  end

  def read_guess(client, parsed_request)
    guess = client.read(parsed_request["Content-Length"].to_i)
  end

  def game(client, parsed_request)
    @guesses += 1
    case parsed_request["Verb"]
    when "GET" then game_get(client, parsed_request)
    when "POST" then game_post(client, parsed_request)
    else ResponseCodes.not_found
    end
  end

  def game_get(client, parsed_request)
    get_response(client, parsed_request)
  end

  def game_post(client, parsed_request)
    @current_guess = read_guess(client, parsed_request).to_i
    puts "This is current guess: #{@current_guess}"
    post_response(client, parsed_request)
  end


  def get_response(client, parsed_request)
    client.puts "http/1.1 #{ResponseCodes.ok}\r\n\n\r"
    client.puts "You've guessed #{@guesses} times\n\r"
    client.puts "Invalid Guess: #{invalid_guess?}\n\r"
    client.puts check_guess
    puts "THis is the last thing that happens"
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
    end
     "this is your current guess: #{@current_guess}" + "\n" + response + "\n\r"
  end
end
