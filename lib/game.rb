require 'player'
require 'pry'
require 'request'
require 'response'
require 'card_deck'

class Game
  attr_reader :turn, :deck
  def initialize(num_of_players)
    @turn = 1
    @players_array = []
    @game_winner = ''
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

  def run_round(json_request)
    request = Request.from_json(json_request)
    original_fisher = request.fisher
    desired_rank = request.rank
    original_target = request.target
    target = find_player(original_target)
    fisher = find_player(original_fisher)
    card = target.card_in_hand(desired_rank)
    if card == "Go Fish!"
      next_turn
      card_refills
      return Response.new(original_fisher, desired_rank, original_target, false)
    else
      fisher.take_card(card)
      fisher.pair_cards
      card_refills
      return Response.new(original_fisher, desired_rank, original_target, true, "#{card.string_value}")
    end
  end

  def next_turn
    if @turn < @players_array.length
      @turn += 1
    else
      @turn = 1
    end
  end

  def card_refills
    @players_array.each do |player|
      if player.cards_left == 0
        5.times do
          if @deck.cards_left == 0
            return nil
          end
          player.take_card(@deck.use_top_card)
        end
      end
    end
  end

  def winner?
    if @deck.cards_left > 0 || @deck == nil
      return false
    end
    @players_array.each do |player|
      unless player.cards_left < 1
        return false
      end
    end
    return true
  end

  def who_is_winner
    high_score = 0
    highest_player = ''
    @players_array.each do |player|
      if player.points > high_score
        high_score = player.points
        highest_player = player
      end
    end
    if high_score == 0
      return "Its a tie!"
    end
    return highest_player
  end

  def clear_deck
    @deck.clear_deck
  end
end
