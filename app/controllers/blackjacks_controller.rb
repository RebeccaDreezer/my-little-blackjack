class BlackjacksController < ApplicationController

  def index
    @blackjacks = current_user.blackjacks

    if params[:id].present?
      @blackjack = Blackjack.find_by(id: params[:id])
    elsif @blackjack.present?
      @blackjack = current_user.blackjacks.find_by(game_state: Blackjack::STATE_ACTIVE)
    end
  end

  def new
    @blackjack = Blackjack.new do |b|
      b.user_id = current_user.id
      b.deck = Blackjack::DECK.shuffle
      b.game_state = Blackjack::STATE_ACTIVE
      b.save
    end
    @blackjack.new_deal

    redirect_to blackjack_url(id: @blackjack.id)
  end

  def show
    @blackjack = Blackjack.find_by(id: params[:id])
  end

  def hit
    @blackjack = Blackjack.find_by(id: params[:id])
    @blackjack.hit

    redirect_to blackjack_url(id: params[:id])
  end

  def stand

  end

  def help

  end

end
