require 'player'
require 'pry'

class Game

  def initialize(num_of_players)
    @turn = 1
    @players_array = []
    @deck = CardDeck.new()
    num_of_players.times do
      @players_array.push(Player.new)
    end

  end

  def distribute_deck
    @players_array.each do |player|
      5.times do
        player.take_card(@deck.use_top_card)
      end
    end
  end


  def find_player(desired_player)
    @players_array[desired_player - 1]
  end

  def run_round
    
  end
end
