require 'pry'

class Player
  def initialize
    @player_hand = []
  end

  def set_hand(deck)
    @player_deck = deck
  end

  def cards_left
    @player_hand.length
  end
end
