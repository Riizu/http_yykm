require 'socket'
require './lib/router'

class Server

  attr_accessor :running, :tcp_server, :request_data

  def initialize
    @running = true
    @tcp_server = TCPServer.new(9292)
    @router = Router.new
  end

  def start
    while @running do
      client = @tcp_server.accept
      request = get_request(client)
      @router.routes(client, request)
      client.close
    end
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
end
