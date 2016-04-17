require './lib/response_codes'

class OutputView
  include ResponseCodes

  def initialize
    @count = 0
  end

  def generate_header(response, code)
    ["http/1.1 #{code}",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{response.length}\r\n\r\n"].join("\n")
  end

  def generate_diagnostic_response(client, request)
    response = "<pre>\n"\
               "Verb: #{request["Verb"]}\n"\
               "Path: #{request["Path"]}\n"\
               "Protocol: #{request["Protocol"]}\n"\
               "Host: #{request["Host"]}\n"\
               "Origin: #{client.addr[2]}\n"\
               "Accept: #{request["Accept"]}\n"\
               "</pre>"

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


  def sys_error(client, response, code)
    begin
      raise SystemError
    rescue Exception => e
      msg = e.backtrace.join("\n")
    end
    client.puts "HTTP1.1 #{ResponseCodes.internal_server_error}\r\n\r\n"
    client.puts response
    client.puts msg
  end

end

#class SystemError < Exception; end
