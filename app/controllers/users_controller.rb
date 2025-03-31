class UsersController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource :partner
  load_and_authorize_resource :user, through: :partner

  def index
    @users = @partner.users
  end

  def new
    @user = @partner.users.build
  end

  def create
    @user.password = Devise.friendly_token

    if @user.save
      flash.now[:success] = "User #{@user.name} created!"
    else
      @show_validations = true
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash.now[:success] = "User #{@user.name} updated!"
    else
      @show_validations = true
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    flash.now[:success] = "User #{@user.name} is removed!"

    @user.destroy
  end

  def resend
    @user.send_token

    flash.now[:success] = "Sign in link sent to #{@user.name} (#{@user.email})"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
