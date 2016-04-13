class Parser
  def parse_request(request_lines)
    request_data = parse_verb_path(request_lines)

    request_lines.each do |line|
      split_line = line.split(": ")
      request_data[split_line[0]] = split_line[1]
    end
    request_data
  end

  def parse_verb_path(request_lines)
    request_data = {}
    verb_path_line = request_lines.shift.split(" ")
    request_data["Verb"] = verb_path_line[0]
    request_data["Path"] = verb_path_line[1]
    request_data["Protocol"] = verb_path_line[2]
    request_data
  end

  def parse_params(request_data)
    split_path = request_data["Path"].split("?")
    request_data["Path"] = split_path[0]
    split_param = split_path[1].split("=")
  end
end
