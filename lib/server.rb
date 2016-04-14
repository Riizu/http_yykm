require 'socket'
require './lib/router'
require './lib/parser'
require 'pp'

class Server

  attr_accessor :running, :tcp_server, :request_data

  def initialize
    @running = true
    @tcp_server = TCPServer.new(9292)
    @router = Router.new
    @parser = Parser.new
  end

  def start
    while @running do
      client = @tcp_server.accept
      request = get_request(client)
      puts "Raw request #{request}"
      parsed_request = @parser.parse_request(request)
      @router.route(client, parsed_request)
      client.close
    end
  end

  def get_request(client)
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end
end
