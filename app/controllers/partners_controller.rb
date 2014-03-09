class PartnersController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :js

  def index
    @partners = Partner.all
  end

  def show
    @partner = Partner.find params.require(:id)
  end

  def create
    @partner = Partner.create params.require(:partner).permit(:name, :email)
    respond_with @partner
  end

  def edit
    @partner = Partner.find params.require(:id)
    respond_with @partner
  end

  def update
    @partner = Partner.find params.require(:id)
    @partner.update params.require(:partner).permit(:name, :email)
    respond_with @partner
  end

  def destroy
    @partner = Partner.find params.require(:id)
    @partner.destroy
  end

  def resend
    partner = Partner.find params.require(:id)
    PartnerMailer.send_token(partner).deliver
  end

end
