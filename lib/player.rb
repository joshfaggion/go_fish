require 'pry'
require_relative 'playing_card'

class Player

  def initialize
    @player_hand = []
  end

  def set_hand(deck)
    @player_hand = deck
  end

  def cards_left
    @player_hand.length
  end

  def card_in_hand(chosen_rank)
    matching_card = []
    @player_hand.each do |card|
      if chosen_rank == card.rank
        matching_card = card
        @player_hand.delete(card)
        return matching_card
      end
    end
    if matching_card == []
      return "Go Fish!"
    end
    return matching_card
  end

  def take_card(card)
    @player_hand.push(card)
  end
end
