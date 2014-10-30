class BlackjacksController < ApplicationController

  def index
    @blackjack = current_user.blackjacks.find_by(game_state: Blackjack::STATE_ACTIVE)
    unless @blackjack.present?
      @blackjack = Blackjack.new do |b|
        b.deck = Blackjack::DECK.shuffle
        b.save
      end
      @blackjack.new_deal
    end
  end

end
