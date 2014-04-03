class UsersController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :js

  def index
    @partners = User.partners

    authorize! :read, User
  end

  def show
    @partner = User.partners.includes(reservations: :item).find params.require(:id)

    authorize! :read, @partner
  end

  def create
    authorize! :create, User

    @partner = User.new partner_params
    @partner.role = "partner"
    @partner.password = (0...8).map { (65 + rand(26)).chr }.join
    @partner.save

    respond_with @partner
  end

  def edit
    @partner = User.partners.find params.require(:id)
    authorize! :update, @partner

    respond_with @partner
  end

  def update
    @partner = User.partners.find params.require(:id)
    authorize! :update, @partner

    @partner.update partner_params

    respond_with @partner
  end

  def destroy
    @partner = User.partners.find params.require(:id)
    authorize! :destroy, @partner

    @partner.destroy
  end

  def resend
    @partner = User.partners.find params.require(:id)
    authorize! :read, @partner

    @partner.send_token
  end

  private
  def partner_params
    params.require(:user).permit(:name, :email)
  end

end
