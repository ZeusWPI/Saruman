class SignInController < ApplicationController

  acts_as_token_authentication_handler_for User
  before_action :authenticate_user!

  def sign_in_partner
    redirect_to user_reservations_path(current_user)
  end

end
