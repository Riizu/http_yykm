require './lib/output_view'
class Router

  def initialize
    @output_view = OutputView.new
  end

  def routes(client, request)

    case request["Path"]
    when "/"
      @output_view.generate_diagnostic_response(client, request)

    when "/hello"
      # TODO: GO TO @HELLO CONTROLLER.Hello
      # client.puts "/hello redirect not yet implemented"
      @output_view.generate_hello_response(client, request)
    when "/datetime"
      # GO TO @DATE CONTROLLER.datetime
      # client.puts "/datetime redirect not yet implemented"
      @output_view.generate_datetime_response(client, request)
    when "/shutdown"
      # @SHUTDOWN CONTROLLER.shutdown (exit inside the controller)
      @output_view.shutdown
    else
      # Do something else
      puts "Nothing to do"
    end

  end


end
