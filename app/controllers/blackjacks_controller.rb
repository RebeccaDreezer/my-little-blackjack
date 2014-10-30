class BlackjacksController < ApplicationController

  def index
    @blackjacks = current_user.blackjacks.order("id DESC")

    current_blackjack = @blackjacks.find_by(game_state: Blackjack::STATE_ACTIVE)
    unless current_blackjack.present?
      #TODO: add a something here to ensure a "new" button gets made
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

    result = @blackjack.evaluate_game
    flash[:notice] = result[:notice] unless result[:state] == Blackjack::STATE_ACTIVE

    redirect_to blackjack_url(id: @blackjack.id)
  end

  def show
    @blackjack = Blackjack.find_by(id: params[:id])
  end

  def hit
    @blackjack = Blackjack.find_by(id: params[:id])
    @blackjack.hit

    result = @blackjack.evaluate_game
    flash[:notice] = result[:notice] unless result[:state] == Blackjack::STATE_ACTIVE

    redirect_to blackjack_url(id: params[:id])
  end

  def stand
    @blackjack = Blackjack.find_by(id: params[:id])
    @blackjack.stand

    result = @blackjack.evaluate_game
    flash[:notice] = result[:notice] unless result[:state] == Blackjack::STATE_ACTIVE

    redirect_to blackjack_url(id: params[:id])
  end

  def help

  end

end
