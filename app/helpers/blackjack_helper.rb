module BlackjackHelper

  def self.display_state(state)
    view_state = case state
    when Blackjack::STATE_ACTIVE then "active"
    when Blackjack::STATE_PLAYER_WIN then "You won!"
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
    [value, 10].min
  end

  def self.hand_value(hand)
    total = 0
    aces_count = 0
    hand.each do |card|
      value = card_value(card)
      aces_count += 1 if value == 1
      total += value
    end
    (1..aces_count).each{ |i| total += 10 if total < (21 - 10) }

    total
  end

end
