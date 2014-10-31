require 'spec_helper'

describe Blackjack do
  let(:blackjack) { Fabricate(:blackjack) }

  before do
    blackjack.game_state = Blackjack::STATE_ACTIVE
  end

  describe '#deal' do
    it 'should return the number of cards that were dealt' do
      expect(blackjack.deal(2).length).to eq(2)
    end

    it 'should reduce the number of cards in the deck' do
      deck_size = blackjack.get_deck.length
      blackjack.deal(4)
      expect(blackjack.get_deck.length).to eq(deck_size - 4)
    end
  end

  describe '#hit' do
    it 'should do nothing if the game isnt active' do
      blackjack.game_state = Blackjack::STATE_USER_WIN
      initial_user_hand_length = blackjack.get_user_hand.length
      blackjack.hit
      expect(blackjack.get_user_hand.length).to eq(initial_user_hand_length)
    end

    it 'should increase the number of cards in a hand' do
      initial_user_hand_length = blackjack.get_user_hand.length
      blackjack.hit
      expect(blackjack.get_user_hand.length).to eq(initial_user_hand_length + 1)
    end
  end

  describe '#stand' do
    it 'should do nothing if the game isnt active' do
      blackjack.game_state = Blackjack::STATE_USER_WIN
      initial_dealer_hand_length = blackjack.get_user_hand.length
      blackjack.hit
      expect(blackjack.get_user_hand.length).to eq(initial_dealer_hand_length)
    end

    it "should add a card if the dealers hand is below #{Blackjack::DEALER_HIT_MAX}" do
      blackjack.dealer_hand = ["c01","c02"]
      initial_dealer_hand_length = blackjack.get_dealer_hand.length
      blackjack.stand
      expect(blackjack.get_user_hand.length > initial_dealer_hand_length).to be_truthy
    end

    it "should do nothing if the dealers hand is at #{Blackjack::DEALER_HIT_MAX}" do
      blackjack.dealer_hand = ["c11","c12","c13"]
      initial_dealer_hand_length = blackjack.get_dealer_hand.length
      blackjack.stand
      expect(blackjack.get_user_hand.length).to eq(initial_dealer_hand_length)
    end
  end

  describe '#evaluate_game' do
    context 'in mid-game' do
      it 'should return STATE_USER_WIN if the user has blackjack' do
        blackjack.user_hand = ["c01","c12"]
        blackjack.dealer_hand = ["d01","d02"]
        expect(blackjack.evaluate_game()[:state]).to eq(Blackjack::STATE_USER_WIN)
      end

      it 'should return STATE_USER_WIN if the user and the dealer both have blackjack' do
        blackjack.user_hand = ["c01","c12"]
        blackjack.dealer_hand = ["d01","d12"]
        expect(blackjack.evaluate_game()[:state]).to eq(Blackjack::STATE_USER_WIN)
      end

      it 'should return STATE_USER_WIN if the dealer busts' do
        blackjack.user_hand = ["c01","c12"]
        blackjack.dealer_hand = ["d11","d12","h12"]
        expect(blackjack.evaluate_game()[:state]).to eq(Blackjack::STATE_USER_WIN)
      end

      it "should return STATE_DEALER_WIN if the user busts" do
        blackjack.dealer_hand = ["c01","c12"]
        blackjack.user_hand = ["d11","d12","h12"]
        expect(blackjack.evaluate_game()[:state]).to eq(Blackjack::STATE_DEALER_WIN)
      end

      it "should return STATE_ACTIVE if the user and the dealer have valid hands" do
        blackjack.dealer_hand = ["c01","c12"]
        blackjack.user_hand = ["d11","d12"]
        expect(blackjack.evaluate_game()[:state]).to eq(Blackjack::STATE_ACTIVE)
      end
    end

    context 'when the game is over' do
      it 'should return STATE_USER_WIN if the user has the better hand' do
        blackjack.user_hand = ["c11","c12"]
        blackjack.dealer_hand = ["d01","d02"]
        expect(blackjack.evaluate_game(true)[:state]).to eq(Blackjack::STATE_USER_WIN)
      end

      it 'should return STATE_DEALER_WIN if the dealer has the better hand' do
        blackjack.user_hand = ["d01","d02"]
        blackjack.dealer_hand = ["c11","c12"]
        expect(blackjack.evaluate_game(true)[:state]).to eq(Blackjack::STATE_DEALER_WIN)
      end

      it 'should return STATE_DEALER_WIN if the user ties the dealer' do
        blackjack.user_hand = ["d11","c12"]
        blackjack.dealer_hand = ["c11","c12"]
        expect(blackjack.evaluate_game(true)[:state]).to eq(Blackjack::STATE_DEALER_WIN)
      end
    end
  end
end
