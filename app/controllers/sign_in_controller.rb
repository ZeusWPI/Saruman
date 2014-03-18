class SignInController < ApplicationController

  acts_as_token_authentication_handler_for Partner
  before_action :authenticate_partner!

  def sign_in_partner
    redirect_to partner_reservations_path(current_partner)
  end

end
