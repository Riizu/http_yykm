require './lib/response_codes'
require './lib/output_view'

class Game
  include ResponseCodes

  attr_reader :running

  def initialize
    @guesses = 0
    @current_guess = 0
    @secret_number = 0
    @running = false
  end

  def running?
    @running
  end

  def start_game(client, parsed_request)
    case parsed_request["Verb"]
    when "POST"
      @running = true
      @current_guess = 0
      @secret_number = rand(100)
      client.puts "http/1.1 #{ResponseCodes.ok}\r\n\r\n"
      client.puts "Good Luck!"
    else
      client.puts "http/1.1 #{ResponseCodes.not_found}\n\r"
    end
  end

  def read_guess(client, parsed_request)
    client.read(parsed_request["Content-Length"].to_i)
  end

  def game(client, parsed_request)
    return not_running_response(client, parsed_request) if !running?
    case parsed_request["Verb"]
    when "GET" then game_get(client, parsed_request)
    when "POST" then game_post(client, parsed_request)
    else ResponseCodes.not_found
    end
  end

  def game_get(client, parsed_request)
    running_response(client, parsed_request)
  end

  def game_post(client, parsed_request)
    @guesses += 1
    @current_guess = read_guess(client, parsed_request).to_i
    post_response(client, parsed_request)
  end

  def not_running_response(client, parsed_request)
    client.puts "http/1.1 #{ResponseCodes.ok}\r\n\n\r"
    client.puts "The game is not currently started! Please start it using a post to /start_game!\n\r"
  end

  def running_response(client, parsed_request)
    client.puts "http/1.1 #{ResponseCodes.ok}\r\n\n\r"
    client.puts "You've guessed #{@guesses} times\n\r"
    client.puts check_guess
  end

  def post_response(client, parsed_request)
    client.puts generate_redirect_header
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
      @running = false
      response = "You guessed the number! It was #{@secret_number}. Please use /start_game to play again!"
    elsif @current_guess > @secret_number
      response = "Your guess was too high"
    elsif @current_guess < @secret_number
      response = "Your guess was too low"
    end
     "this is your current guess: #{@current_guess}" + "\n" + response + "\n\r"
  end
end
