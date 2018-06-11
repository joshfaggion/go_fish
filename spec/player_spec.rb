require 'rspec'
require 'player'

describe '#player?' do
  it 'should initialize him with zero cards' do
    player = Player.new()
    expect(player.cards_left).to eq 0
  end

  it 'should tell if a certain card is in the players deck' do
    player = Player.new()
    player.set_hand([PlayingCard.])
  end
end
