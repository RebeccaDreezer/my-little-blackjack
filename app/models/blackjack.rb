class Blackjack < ActiveRecord::Base
  belongs_to :user

  STATE_ACTIVE = 0
  STATE_USER_WIN = 1
  STATE_DEALER_WIN = 2

  DECK = [
    'c01', 'c02', 'c03', 'c04', 'c05', 'c06', 'c07', 'c08', 'c09', 'c10', 'c11', 'c12', 'c13',
    'd01', 'd02', 'd03', 'd04', 'd05', 'd06', 'd07', 'd08', 'd09', 'd10', 'd11', 'd12', 'd13',
    'h01', 'h02', 'h03', 'h04', 'h05', 'h06', 'h07', 'h08', 'h09', 'h10', 'h11', 'h12', 'h13',
    's01', 's02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10', 's11', 's12', 's13'
  ]
  DEALER_HIT_MAX = 16

  scope :active, -> { where(game_state: STATE_ACTIVE) }

  def update_deck(deck)
    self.update_attributes(deck: dump_array(deck))
  end

  def new_deal
    user_hand = self.deal(2)
    dealer_hand = self.deal(2)
    self.update_attributes(user_hand: user_hand, dealer_hand: dealer_hand)
  end

  def deal(num_cards = 1)
    deck = load_array(self.deck)
    cards = []
    (1..num_cards).each{ cards << deck.pop }
    update_deck(deck)
    cards
  end

  def hit
    return if self.game_state != STATE_ACTIVE
    old_user_hand = load_array(self.user_hand)
    new_user_hand = old_user_hand.push *deal
    self.update_attributes(user_hand: new_user_hand)
  end

  def stand
    return if self.game_state != STATE_ACTIVE
    old_dealer_hand = load_array(self.dealer_hand)
    new_dealer_hand = []
    while BlackjackHelper.hand_value(old_dealer_hand) < DEALER_HIT_MAX do
      new_dealer_hand = old_dealer_hand.push *deal
    end
    self.update_attributes(dealer_hand: new_dealer_hand) unless new_dealer_hand.empty?
  end

  def get_user_hand
    load_array(self.user_hand)
  end

  def get_dealer_hand
    load_array(self.dealer_hand)
  end

  def get_user_score
    BlackjackHelper.hand_value(self.get_user_hand)
  end

  def evaluate_game(end_game = false)
    user_hand = load_array(self.user_hand)
    dealer_hand = load_array(self.dealer_hand)
    user_hand_value = BlackjackHelper.hand_value(user_hand)
    dealer_hand_value = BlackjackHelper.hand_value(dealer_hand)
    results = {}

    if user_hand_value == 21 && user_hand.length == 2
      results = {state: STATE_USER_WIN, notice: "You got blackjack!"}
    elsif user_hand_value > 21
      results = {state: STATE_DEALER_WIN, notice: "You busted. Dealer wins!"}
    elsif dealer_hand_value > 21
      results = {state: STATE_USER_WIN, notice: "Dealer busted. You win!"}
    elsif end_game
      if user_hand_value > dealer_hand_value
        results = {state: STATE_USER_WIN, notice: "You beat the dealer. You win!"}
      elsif user_hand_value == dealer_hand_value
        results = {state: STATE_DEALER_WIN, notice: "The dealer tied you. You lose!"}
      else
        results = {state: STATE_DEALER_WIN, notice: "The dealer beat you. You lose!"}
      end
    else
      results = {state: STATE_ACTIVE}
    end

    self.update_attributes(game_state: results[:state])
    return results
  end

  private

  def load_array(hand)
    if hand.is_a? String
      YAML.load(hand)
    else
      hand
    end
  end

  def dump_array(hand)
    if hand.is_a? String
      hand
    else
      YAML.dump(hand)
    end
  end

end
