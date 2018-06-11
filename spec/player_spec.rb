require 'rspec'
require 'player'

describe '#player?' do
  it 'should initialize him with zero cards' do
    player = Player.new()
    expect(player.cards_left).to eq 0
  end

  it 'should tell if a certain card is in the players deck' do
    player = Player.new()
    player.set_hand([PlayingCard.new('8', 'Spades'), PlayingCard.new('10', 'Hearts')])
    desired_card = PlayingCard.new('8', 'Hearts')
    expect(player.card_in_hand(desired_card)).to eq "When we searched for 8 in your enemies hand, we found 1."
  end
end
