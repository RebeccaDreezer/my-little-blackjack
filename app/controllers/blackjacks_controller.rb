class BlackjacksController < ApplicationController
  def index
    @blackjacks = current_user.blackjacks.order("id DESC")
  end

  def create
    if current_user.blackjacks.active.count > 3
      flash[:notice] = "You've already got some active games..."
      redirect_to blackjacks_url
      return
    end

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
    unless result[:state] == Blackjack::STATE_ACTIVE
      flash[:notice] = result[:notice]
      current_user.increment_user_score(@blackjack.game_state)
    end

    redirect_to blackjack_url(id: params[:id])
  end

  def stand
    @blackjack = Blackjack.find_by(id: params[:id])
    @blackjack.stand

    result = @blackjack.evaluate_game(true)

    unless result[:state] == Blackjack::STATE_ACTIVE
      flash[:notice] = result[:notice]
      current_user.increment_user_score(@blackjack.game_state)
    end

    redirect_to blackjack_url(id: params[:id])
  end
end
