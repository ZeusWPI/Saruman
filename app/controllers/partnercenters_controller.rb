class PartnercentersController < ApplicationController
  acts_as_token_authentication_handler_for Partner

  def sign_in
    redirect_to action: :show
  end

  def show
  end

end
