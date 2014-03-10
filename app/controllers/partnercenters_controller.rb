class PartnercentersController < ApplicationController
  acts_as_token_authentication_handler_for Partner

  def show
    @items = Items.all
  end

end
