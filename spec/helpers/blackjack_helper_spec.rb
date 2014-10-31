require 'spec_helper'

describe BlackjackHelper do
  describe '.card_value' do
    it 'should return the numeric value of a 2-9 card' do
      card = (2..9).to_a.sample
      expect(BlackjackHelper.card_value("c0#{card}")).to eq(card)
    end

    it 'should return the value of 11 for an ace' do
      expect(BlackjackHelper.card_value("s01")).to eq(11)
    end

    it 'should return the numeric value of an 11-13 face card' do
      expect(BlackjackHelper.card_value("h13")).to eq(10)
      expect(BlackjackHelper.card_value("d11")).to eq(10)
    end
  end

  describe '.hand_value' do
    it 'should compute the value of a hand' do
      hands = [
        {deck: ["c04","d10"], value: 14},
        {deck: ["s13"], value: 10},
        {deck: ["c02","d02","h02","s04","c10","c11"], value: 30}
      ]
      hands.each do |hand|
        expect(BlackjackHelper.hand_value(hand[:deck])).to eq(hand[:value])
      end
    end

    context 'with an ace' do
      it 'should count an ace as an 11 by default' do
        hand = ["d01","s02"]
        expect(BlackjackHelper.hand_value(hand)).to eq(13)
      end

      it 'should count an ace as a 1 if the sum is over 21' do
        hand = ["h08","c11","c01"]
        expect(BlackjackHelper.hand_value(hand)).to eq(19)
      end

      it 'should count aces as different values' do
        hand = ["s08","c01","d01"]
        expect(BlackjackHelper.hand_value(hand)).to eq(20)
      end
    end
  end
end
