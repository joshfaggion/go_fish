require 'pry'
require 'socket'
require_relative 'game'
require_relative 'request'


class SocketServer
  def initialize
    @games={}
    @lobbies = []
    @pending_clients = []
  end

  def accept_new_client(client='Random Player')
    # This will welcome the players, and direct them to the lobby.
    lobby_complete = lobbies.last[2]
    num_of_players = lobbies.last[0]
    joined_players = lobbies.last[1]
    client_connection = server.accept_nonblock
    pending_clients.push(client_connection)
    if lobby_complete == false
      if num_of_players > pending_clients.length
        client_connection.puts ["Welcome, we are currently waiting for more players. You are Player #{joined_players + 1}.", joined_players]
        # For some reason I can't use joined_players here. Food for thought.
        lobbies.last[1] += 1
        return false
      else
         client_connection.puts ["Welcome, a game lobby is complete! You are Player #{joined_players + 1}.", joined_players]
         lobby_complete = true
         return create_game(3)
      end
    else
      client_connection.puts "Creating New Lobby... You are Player One."
      create_game_lobby(3)
      joined_players += 1
      return false
    end
  rescue IO::WaitReadable, Errno::EINTR
    sleep(0.1)
    return false
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
      # This is only called if game lobby is full and confirmed.
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
    # For testing purposes.
    player = game.find_player(player)
    player.set_hand(cards)
  end

  def show_player_cards(game)
    # Shows the player his cards.
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
    # Runs a round, and makes a response object.
    response = game.run_round(request)
    return response
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
