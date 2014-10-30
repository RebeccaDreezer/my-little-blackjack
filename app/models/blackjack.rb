class Blackjack < ActiveRecord::Base
  belongs_to :user

  STATE_ACTIVE = 0
  STATE_PLAYER_WIN = 1
  STATE_DEALER_WIN = 2

  DECK = [
    'c01', 'c02', 'c03', 'c04', 'c05', 'c06', 'c07', 'c08', 'c09', 'c10', 'c11', 'c12', 'c13',
    'd01', 'd02', 'd03', 'd04', 'd05', 'd06', 'd07', 'd08', 'd09', 'd10', 'd11', 'd12', 'd13',
    'h01', 'h02', 'h03', 'h04', 'h05', 'h06', 'h07', 'h08', 'h09', 'h10', 'h11', 'h12', 'h13',
    's01', 's02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10', 's11', 's12', 's13'
  ]

  def new_deal
    user_hand = self.deal(2)
    dealer_hand = self.deal(2)
    self.update_attributes(user_hand: user_hand, dealer_hand: dealer_hand)
  end

  def deal(num_cards = 1)
    deck = load_array(self.deck)
    cards = []
    (1..num_cards).each{ cards << deck.pop }
    self.deck = deck
    self.save!

    cards
  end

  def hit
    return if self.game_state != STATE_ACTIVE
    old_user_hand = load_array(self.user_hand)
    new_user_hand = old_user_hand.push *deal
    self.update_attributes(user_hand: new_user_hand)
  end

  def get_user_hand
    load_array(self.user_hand)
  end

  def get_dealer_hand
    load_array(self.dealer_hand)
  end

  private

  def load_array(hand)
    if hand.is_a? String
      YAML.load(hand)
    else
      hand
    end
  end

end
