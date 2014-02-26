class PartnersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html, :js

  def index
    @partners = Partner.all
  end

  def show
  end

  def new
  end

  def create
    authorize! :create, Partner

    @partner = Partner.create params.require(:partner).permit(:name, :email)

    respond_with @partner
  end

  def edit
  end

  def update
    authorize! :update, @partner
    if @partner.update params.require(:partner).permit(:name, :email)
      flash.now[:success] = "Succesfully updated partner."
    end

    render action: :edit
  end

  def destroy
    @partner.destroy
    redirect_to action: :index
  end

  def resend
    @partner = Partner.find params.require(:partner_id)
    authorize! :show, @partner
    PartnerMailer.send_token(@partner).deliver
  end
end
