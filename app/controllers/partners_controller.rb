class PartnersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html, :js

  def index
    @partners = Partner.all
  end

  def show
    @partner = Partner.find params.require(:id)
  end

  def create
    @partner = Partner.create partner_params
    respond_with @partner
  end

  def edit
    @partner = Partner.find params.require(:id)
    respond_with @partner
  end

  def update
    @partner = Partner.find params.require(:id)
    @partner.update partner_params
    respond_with @partner
  end

  def destroy
    @partner = Partner.find params.require(:id)
    @partner.destroy
  end

  def resend
    @partner = Partner.find params.require(:id)
    @partner.send_token
  end

  private
  def partner_params
    params.require(:partner).permit(:name, :email)
  end

end
