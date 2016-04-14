require './lib/response_codes'

class OutputView
  include ResponseCodes

  def initialize
    @count = 0
  end

  # def output(client, OutputView.send(method, params), code)
  #   client.puts generate_header(response, code)
  #   client.puts response
  # end

  def generate_header(response, code)
    ["http/1.1 #{code}",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{response.length}\r\n\r\n"].join("\n")
  end

  def generate_diagnostic_response(client, request)
    response = "<pre><br>Verb: #{request["Verb"]}<br>"\
               "Path: #{request["Path"]}<br>"\
               "Protocol: #{request["Protocol"]}<br>"\
               "Host: #{request["Host"]}<br>"\
               "Origin: #{client.addr[2]}<br>"\
               "Accept: #{request["Accept"]}<br></pre>"

    client.puts generate_header(response, ResponseCodes.ok)
    client.puts response
  end

  def generate_hello_response(client)
    @count += 1
    response = "Hello, World! #{@count}"
    client.puts generate_header(response, ResponseCodes.ok)
    client.puts response
  end

  def generate_datetime_response(client)
    response = Time.now.strftime('%I:%M%p on %A, %B %d, %Y')
    client.puts generate_header(response, ResponseCodes.ok)
    client.puts response
  end

  def get_words
    file = '/usr/share/dict/words'
    File.readlines(file).map { |line| line.chomp }
  end

  def generate_word_search_response(client, parsed_request)
    words = get_words
    if parsed_request["Params"] == nil
      response = "404 Not Found"
      client.puts generate_header(response, ResponseCodes.not_found)
      client.puts response
    elsif words.include?(parsed_request["Params"].values[0])
      response = "#{parsed_request["Params"].values[0]} is a known word!"
      client.puts generate_header(response, ResponseCodes.ok)
      client.puts response
    else
      response =  "#{parsed_request["Params"].values[0]} is a unknown word!"
      client.puts generate_header(response, ResponseCodes.ok)
      client.puts response
    end
  end

  def shutdown(client, num_routes)
    response = "Total requests: #{num_routes}"
    client.puts generate_header(response, ResponseCodes.ok)
    client.puts response
    exit
  end

  def error(client, response, code)
    client.puts generate_header(response, code)
    client.puts response
  end

end
