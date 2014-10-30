class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(permitted_params)
    if @user.save
      redirect_to root_url, :notice => "Signed up! Now log in!"
    else
      render "new"
    end
  end

  def permitted_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
