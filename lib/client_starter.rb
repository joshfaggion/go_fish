require_relative 'socket_server'
require 'json'
require_relative 'client'
require 'socket'

client = Client.new(3002)
while true
  output = client.take_in_output
  puts output
end
