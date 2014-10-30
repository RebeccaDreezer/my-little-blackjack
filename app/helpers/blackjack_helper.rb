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

end
