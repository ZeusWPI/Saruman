class UsersController < ApplicationController
  before_filter :authenticate_user!

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      redirect_to users_path
    else
      render :new
    end

  end

  def index
    @users = User.all
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
