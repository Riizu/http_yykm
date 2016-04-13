require './lib/output_view'

class Router

  def initialize
    @output_view = OutputView.new
    @num_routes = 0
  end

  def route(client, request, params=nil)
    @num_routes += 1

    case request["Path"]
    when "/"
      @output_view.generate_diagnostic_response(client, request)

    when "/hello"
      # TODO: GO TO @HELLO CONTROLLER.Hello
      @output_view.generate_hello_response(client, request)
    when "/datetime"
      # GO TO @DATE CONTROLLER.datetime
      @output_view.generate_datetime_response(client, request)
    when "/shutdown"
      # @SHUTDOWN CONTROLLER.shutdown (exit inside the controller)
      @output_view.shutdown(client, @num_routes)
    when "/word_search"
      #@output_view.generate_word_search_response(client, request, params)
    else
      puts "Received unknown request!"
    end

  end
end
