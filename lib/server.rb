class Server
  require 'socket'

  attr_accessor :running, :tcp_server

  def initialize
    @running = true
  end

  def start
    num_runs = 0
    tcp_server = TCPServer.new(9292)
    while running? do
      client = tcp_server.accept
      num_runs += 1

      client.puts generate_response(get_request(client), "Hello World! #{num_runs/2}")
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
    request_lines
  end

  def generate_response(request_lines, response)
    headers = ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{response.length}"].join("<br>")
    output = "<html><head></head><body>#{request_lines}<br><br>#{headers}<br><br>
    #{response}</body></html>"
    output
  end

end
