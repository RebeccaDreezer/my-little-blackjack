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
    flash[:notice] = result[:notice] unless result[:state] == Blackjack::STATE_ACTIVE

    redirect_to blackjack_url(id: params[:id])
  end

  def stand
    @blackjack = Blackjack.find_by(id: params[:id])
    @blackjack.stand

    result = @blackjack.evaluate_game(true)
    flash[:notice] = result[:notice] unless result[:state] == Blackjack::STATE_ACTIVE

    current_user.user_stat.increment!(:wins) if @blackjack.game_state == Blackjack::STATE_USER_WIN
    current_user.user_stat.increment!(:losses) if @blackjack.game_state == Blackjack::STATE_DEALER_WIN

    redirect_to blackjack_url(id: params[:id])
  end
end
