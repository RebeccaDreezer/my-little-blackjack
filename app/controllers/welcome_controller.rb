class WelcomeController < ApplicationController

  def create_user
    unless params[:name].present?
      flash[:login_error] = "You forgot to enter a name!"
      redirect_to root_url
      return
    end

    @current_user = User.create(name: params[:name])

    debugger

    if @current_user
      redirect_to blackjack_url
    else
      flash[:login_error] = "Whoops! I cannot let you in."
      redirect_to root_url
    end
  end
end
