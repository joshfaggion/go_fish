require 'socket'
require_relative 'socket_server'


server = SocketServer.new
server.start
server.create_game_lobby(3)
loop do
  game = server.accept_new_client
  if game
    Thread.new do
      binding.pry
      server.run_game
    end
  end
end
