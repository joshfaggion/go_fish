require 'pry'
require 'socket'
require 'game'
require 'request'


class SocketServer
  def initialize
    @games={}
    @lobbies = []
    @pending_clients = []
  end

  def accept_new_client(client='Random Player')
    lobby_existing = lobbies.last[2]
    num_of_players = lobbies.last[0]
    joined_players = lobbies.last[1]
    client_connection = server.accept_nonblock
    pending_clients.push(client_connection)
    if lobby_existing == false
      if num_of_players > pending_clients.length
        client_connection.puts "Welcome, we are currently waiting for more players. You are Player #{joined_players + 1}."
        lobbies.last[1] += 1
      else
         client_connection.puts "Welcome, a game lobby is complete! You are Player #{joined_players + 1}."
         lobby_existing = true
      end
    else
      client_connection.puts "Creating a lobby... You are Player One."
      create_game_lobby(4)
      joined_players += 1
    end
  rescue IO::WaitReadable, Errno::EINTR
    sleep(0.1)
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def stop
    server.close if server
  end

  def create_game_lobby(num_of_players)
    joined_players = 0
    lobbies.push([num_of_players, joined_players, false])
  end

  def create_game(num_of_players)
      game = Game.new(num_of_players)
      game.begin_game
      games.store(game, pending_clients.shift(num_of_players))
      return game
  end

  def port_number
    3002
  end

  def num_of_games
    games.keys.length
  end

  def set_player_hand(player, cards, game)
    player = game.find_player(player)
    player.set_hand(cards)
  end

  def show_player_cards(game)
    clients = games[game]
    clients.each do |client|
      client_num = clients.index(client)
      cards = game.players_array[client_num].player_hand
      cards.each do |card|
        client.puts card.string_value
      end
    end
  end

  def run_round(request, game)
    response = game.run_round(request)
    return response
  end

  def get_request(game)
    sleep(0.1)
    clients = games[game]
    turn = game.turn - 1
    current_client = clients[turn]
    string_request = current_client.read_nonblock(100)
    regex = /(player\d).*\s(\w+)/i
    matches = string_request.match(regex)
    return Request.new(game.turn, matches[2].downcase, matches[1][-1].to_i)
  rescue
    request = 'Nothing here. :('
  end

  private

  def games
    @games
  end

  def pending_clients
    @pending_clients
  end

  def lobbies
    @lobbies
  end

  def server
    @server
  end
end












# Hey Mate
