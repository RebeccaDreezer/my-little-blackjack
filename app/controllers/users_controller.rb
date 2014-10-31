class UsersController < ApplicationController
  def new
    if current_user.present?
      redirect_to blackjacks_url
      return
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(permitted_params)
    if @user.save
      UserStat.create(user_id: @user.id)
      redirect_to root_url, :notice => "Signed up! Now log in!"
    else
      render "new"
    end
  end

  def stats
  end

  def permitted_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
