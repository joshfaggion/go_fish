require 'socket_server'
require 'socket'
require 'request'
require 'response'

class MockSocketClient
  def initialize(port)
    @socket = TCPSocket.new 'localhost', port
  end

  def enter_input(input)
    @socket.puts(input)
  end

  def take_in_output(delay=0.1)
    sleep(delay)
    @output = @socket.read_nonblock(3000)
  rescue IO::WaitReadable
    @output='No output to take.'
  end

  def close_socket
    @socket.close if @socket
  end
end

describe '#SocketServer' do
  before(:each) do
    @clients = []
    @server = SocketServer.new()
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close_socket
    end
  end


  context 'When your running the game,' do

    it 'should join five players and connect the to a game' do
      @server.start
      @server.create_game_lobby(5)
      client1 = MockSocketClient.new(@server.port_number)
      @clients.push(client1)
      @server.accept_new_client
      client2 = MockSocketClient.new(@server.port_number)
      @clients.push(client2)
      @server.accept_new_client
      client3 = MockSocketClient.new(@server.port_number)
      @clients.push(client3)
      @server.accept_new_client
      client4 = MockSocketClient.new(@server.port_number)
      @clients.push(client4)
      @server.accept_new_client
      client5 = MockSocketClient.new(@server.port_number)
      @clients.push(client5)
      @server.accept_new_client
      game = @server.create_game(5)
      expect(client1.take_in_output).to eq "Welcome, we are currently waiting for more players. You are Player 1.\n"
      expect(client5.take_in_output).to eq "Welcome, a game lobby is complete! You are Player 5.\n"
      expect(@server.num_of_games).to eq 1
    end

    it 'should tell them what cards they have at the beginning of the game' do
      @server.start
      num_of_players = 3
      @server.create_game_lobby(num_of_players)
      client1 = MockSocketClient.new(@server.port_number)
      @clients.push(client1)
      @server.accept_new_client
      client2 = MockSocketClient.new(@server.port_number)
      @clients.push(client2)
      @server.accept_new_client
      client3 = MockSocketClient.new(@server.port_number)
      @clients.push(client3)
      @server.accept_new_client
      client1.take_in_output
      client2.take_in_output
      game = @server.create_game(num_of_players)
      @server.set_player_hand(1, [PlayingCard.new('10', "Clubs"), PlayingCard.new('5', "Clubs")], game)
      @server.set_player_hand(2, [PlayingCard.new('Queen', "Hearts"), PlayingCard.new('Ace', "Diamonds")], game)
      @server.show_player_cards(game)
      expect(client1.take_in_output).to eq "10 of Clubs\n5 of Clubs\n"
      expect(client2.take_in_output).to eq "Queen of Hearts\nAce of Diamonds\n"
    end

    it 'should run a round completely' do
      @server.start
      num_of_players = 3
      @server.create_game_lobby(num_of_players)
      client1 = MockSocketClient.new(@server.port_number)
      @clients.push(client1)
      @server.accept_new_client
      client2 = MockSocketClient.new(@server.port_number)
      @clients.push(client2)
      @server.accept_new_client
      client3 = MockSocketClient.new(@server.port_number)
      @clients.push(client3)
      @server.accept_new_client
      game = @server.create_game(num_of_players)
      client1.take_in_output
      client2.take_in_output
      client3.take_in_output
      @server.set_player_hand(1, [PlayingCard.new('Jack', "Clubs"), PlayingCard.new('Jack', "Diamonds"), PlayingCard.new('Jack', "Spades")], game)
      @server.set_player_hand(2, [PlayingCard.new('Jack', "Hearts"), PlayingCard.new('Ace', "Diamonds"), PlayingCard.new('Ace', "Hearts")], game)
      json_request = Request.new(1, 'Jack', 2).to_json
      response = @server.run_round(json_request, game)
      expect(response.card_found).to eq true
   end

   it 'should get a request from the client' do
     @server.start
     num_of_players = 3
     @server.create_game_lobby(num_of_players)
     client1 = MockSocketClient.new(@server.port_number)
     @clients.push(client1)
     @server.accept_new_client
     client2 = MockSocketClient.new(@server.port_number)
     @clients.push(client2)
     @server.accept_new_client
     client3 = MockSocketClient.new(@server.port_number)
     @clients.push(client3)
     @server.accept_new_client
     game = @server.create_game(num_of_players)
     client1.take_in_output
     client2.take_in_output
     client3.take_in_output
     @server.set_player_hand(1, [PlayingCard.new('Jack', "Clubs"), PlayingCard.new('Jack', "Diamonds"), PlayingCard.new('Jack', "Spades")], game)
     @server.set_player_hand(2, [PlayingCard.new('Jack', "Hearts"), PlayingCard.new('Ace', "Diamonds"), PlayingCard.new('Ace', "Hearts")], game)
     client1.enter_input('Ask player2 for a Jack.')
     request = @server.get_request(game)
     expect(request.rank).to eq 'jack'
     expect(request.target).to eq 2
     expect(request.fisher).to eq 1
   end
 end
end
