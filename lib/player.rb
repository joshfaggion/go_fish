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

  def card_in_hand?(chosen_rank)
    matching_cards = []
    @player_hand.each do |card|
      if chosen_rank == card.rank
        matching_cards.push()
        @player_hand.delete(card)
      end
  end
  num_of_matching_cards = matching_cards.length
  return "When we searched for #{chosen_rank} in the enemies hand, we found #{num_of_matching_cards}."
end
