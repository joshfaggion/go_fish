require 'json'
require 'request'
require 'response'

class Client
  attr_reader :player_id
  def initialize(port)
    @socket = TCPSocket.new 'localhost', port
  end

  def enter_input(input)
    @socket.puts(input)
  end

  def take_in_output(delay=0.01)
    sleep(delay)
    @output = @socket.read_nonblock(3000)
  rescue IO::WaitReadable
    @output='No output to take.'
  end

  def close_socket
    @socket.close if @socket
  end

  def turn_into_request(string)
    regex = /(player\d).*\s(\w+)/i
    matches = string.match(regex)
    return Request.new(@player_id, matches[2].downcase, matches[1][-1].to_i)
  end

  # Just pass in the output and it will decipher which client you are.
  def set_player_id(output)
    player_id = output[-2].to_i
    @player_id = player_id + 1
  end

  def response_from_json(json_response)
    response = Response.from_json(json_response)
    return response
  end

  def use_response(response)

  end
end
