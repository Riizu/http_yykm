class Parser
  def parse_request(request_lines)
    request_hash = parse_verb_path_protocol(request_lines)
    parse_params(request_hash) if params_exist?(request_hash)
    request_hash = parse_remaining_data(request_lines, request_hash)
    request_hash
  end

  def params_exist?(request_hash)
    return request_hash["Path"].include?("?") ? true : false
  end

  def parse_verb_path_protocol(request_lines)
    request_hash = {}
    verb_path_line = request_lines.shift.split(" ")
    request_hash["Verb"] = verb_path_line[0]
    request_hash["Path"] = verb_path_line[1]
    request_hash["Protocol"] = verb_path_line[2]
    request_hash
  end

  def parse_params(request_hash)
    split_path = request_hash["Path"].split("?")
    request_hash["Path"] = split_path[0]
    split_param = split_path[1].split("=")
    request_hash["Params"] = {split_param[0] => split_param[1]}
  end

  def parse_remaining_data(request_lines, request_hash)
    request_lines.each do |line|
      split_line = line.split(": ")
      request_hash[split_line[0]] = split_line[1]
    end
    request_hash
  end
end
