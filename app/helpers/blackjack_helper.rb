module BlackjackHelper
  def self.display_results(blackjack)
    view_state = case blackjack.game_state
    when Blackjack::STATE_USER_WIN then "#{blackjack.user.name} wins!"
    when Blackjack::STATE_DEALER_WIN then "Dealer wins!"
    else ""
    end
    view_state
  end

  def self.display_results_short(state)
    view_state = case state
    when Blackjack::STATE_ACTIVE then "active"
    when Blackjack::STATE_USER_WIN then "You won!"
    when Blackjack::STATE_DEALER_WIN then "Dealer won :("
    else "unknown :("
    end
    view_state
  end

  def self.get_card_classes(card)
    suit = self.get_suit(card.slice(0))
    face = card.slice(1,2).to_i
    return suit.concat("-#{face}")
  end

  def self.get_suit(char)
    suit = case char
    when "c" then "butterflies"
    when "d" then "diamonds"
    when "s" then "stars"
    when "h" then "apples"
    end
    return suit
  end

  def self.card_value(card)
    value = card.slice(1, 2).to_i
    value == 1 ? value = 11 : [value, 10].min
  end

  def self.hand_value(hand)
    total_aces = 0
    total = 0
    hand.each do |card|
      total_aces += 1 if card.slice(1, 2).to_i == 1
      total += card_value(card)
    end

    (1..total_aces).each{ |i| total -= 10 if total > 21 }
    total
  end
end
