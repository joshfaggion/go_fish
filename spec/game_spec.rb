require 'rspec'
require 'pry'
require 'game'

describe '#game?' do
  it 'should distribute the deck and start the game' do
    num_of_players = 2
    game = Game.new(2)
    game.distribute_deck()
    player = game.find_player(1)
    expect(player.cards_left).to eq 5
  end

  it 'should run a round' do
    num_of_players = 3
    game = Game.new(num_of_players)
    
  end
end
