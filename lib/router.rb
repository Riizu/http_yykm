require './lib/output_view'

class Router

  def initialize
    @output_view = OutputView.new
    @num_routes = 0
  end

  def route(client, parsed_request)
    @num_routes += 1

    case parsed_request["Path"]
    when "/"
      @output_view.generate_diagnostic_response(client, parsed_request)

    when "/hello"
      # TODO: GO TO @HELLO CONTROLLER.Hello
      @output_view.generate_hello_response(client, parsed_request)
    when "/datetime"
      # GO TO @DATE CONTROLLER.datetime
      @output_view.generate_datetime_response(client, parsed_request)
    when "/shutdown"
      # @SHUTDOWN CONTROLLER.shutdown (exit inside the controller)
      @output_view.shutdown(client, @num_routes)
    when "/word_search"
      @output_view.generate_word_search_response(client, parsed_request)
    else
      puts "Received unknown parsed_request!"
    end

  end
end
