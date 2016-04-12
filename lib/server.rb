class Server
  require 'socket'

  attr_accessor :running, :tcp_server, :request_data

  def initialize
    @running = true
    @num_runs = 0
    @tcp_server = TCPServer.new(9292)
  end

  def start
    while running? do
      client = @tcp_server.accept

      request = get_request(client)

      if request["Path"] == "/" #TODO Replace with valid_request(request)
        @num_runs += 1

        response = generate_diagnostic_response(client, request)
        header = generate_header(client, response)

        client.puts header
        client.puts response
      end

      client.close
    end
  end

  def running?
    @running
  end

  def get_request(client)
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end

    parse_request(request_lines)
  end

  def parse_request(request_lines)
    request_data = {}
    verb_path_line = request_lines.shift.split(" ")
    request_data["Verb"] = verb_path_line[0]
    request_data["Path"] = verb_path_line[1]
    request_data["Protocol"] = verb_path_line[2]

    request_lines.each do |line|
      split_line = line.split(": ")
      request_data[split_line[0]] = split_line[1]
    end
    request_data
  end

  def generate_header(client, response)
    header = ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{response.length}\r\n\r\n"].join("\n")
    header
  end

  def generate_diagnostic_response(client, request)
    response =
    "<pre>
Verb: #{request["Verb"]}
Path: #{request["Path"]}
Protocol: #{request["Protocol"]}
Host: #{request["Host"]}
Origin: #{client.addr[2]}
Accept: #{request["Accept"]}
</pre>"
    response
  end

end
