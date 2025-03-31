class SignInController < ApplicationController

  acts_as_token_authentication_handler_for User
  before_action :authenticate_user!

  def sign_in_partner
    redirect_to partner_reservations_path(current_user.partner)
  end
end
