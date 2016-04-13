class OutputView
  def initialize
    @count = 0
  end

  def response(request_lines)
    puts "Sending response."
    response = "<pre>" + request_lines.join("\n") + "</pre>"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
  end

  def generate_header(client, response)
    #TODO: Iteration 5 will need to make the "200 ok" CODE dynamic
    header = ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{response.length}\r\n\r\n"].join("\n")
    header
  end

  def generate_diagnostic_response(client, request)
    response = "<pre><br>Verb: #{request["Verb"]}<br>"\
               "Path: #{request["Path"]}<br>"\
               "Protocol: #{request["Protocol"]}<br>"\
               "Host: #{request["Host"]}<br>"\
               "Origin: #{client.addr[2]}<br>"\
               "Accept: #{request["Accept"]}<br></pre>"

    client.puts generate_header(client, response)
    client.puts response
  end

  def generate_hello_response(client, request)
    @count += 1
    response = "Hello, World! #{@count}"
    client.puts generate_header(client, response)
    client.puts response
  end

  def generate_datetime_response(client, request)
    response = Time.now.strftime('%I:%M%p on %A, %B %d, %Y')
    client.puts generate_header(client, response)
    client.puts response
  end

  def shutdown
    exit
  end

end
