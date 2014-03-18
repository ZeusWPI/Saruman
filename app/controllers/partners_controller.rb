class PartnersController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :js

  def index
    @partners = Partner.all
    authorize! :read, Partner
  end

  def show
    @partner = Partner.find params.require(:id)
    authorize! :read, @partner

    @reservations = @partner.reservations
  end

  def create
    authorize! :create, Partner

    @partner = Partner.create partner_params

    respond_with @partner
  end

  def edit
    @partner = Partner.find params.require(:id)
    authorize! :update, @partner

    respond_with @partner
  end

  def update
    @partner = Partner.find params.require(:id)
    authorize! :update, @partner

    @partner.update partner_params

    respond_with @partner
  end

  def destroy
    @partner = Partner.find params.require(:id)
    authorize! :destroy, @partner

    @partner.destroy
  end

  def resend
    @partner = Partner.find params.require(:id)
    authorize! :read, @partner

    @partner.send_token
  end

  private
  def partner_params
    params.require(:partner).permit(:name, :email)
  end

end
