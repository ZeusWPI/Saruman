class ReservationsController < ApplicationController
  before_action :authenticate_user!

  respond_to :html, :js

  def index
    @partner = User.partners.find params.require(:user_id)

    authorize! :show, @partner

    @reservations = @partner.reservations

    @price = 0
    @reservations.each { |r| @price += r.count*r.item.price }
  end

  def show
    @partner = User.partners.find params.require(:user_id)
    @reservation = @partner.reservations.find params.require(:id)

    authorize! :show, @partner
  end

  def create
    @partner = User.partners.find params.require(:user_id)
    authorize! :show, @partner
    authorize! :create, Reservation

    item = Item.find params.require(:reservation).require(:item_id)

    @reservation = @partner.reservations.new reservation_params
    @reservation.item = item
    @reservation.save

    respond_with @reservation
  end

  def edit
    @partner = User.partners.find params.require(:user_id)

    @reservation = @partner.reservations.find params.require(:id)
    authorize! :update, @reservation
    respond_with @reservation
  end

  def update
    @partner = User.partners.find params.require(:user_id)
    authorize! :show, @partner

    @reservation = @partner.reservations.find params.require(:id)
    authorize! :update, @reservation

    @reservation.update reservation_params
    respond_with @reservation
  end

  def destroy
    @partner = User.partners.find params.require(:user_id)
    authorize! :show, @partner
    @reservation = @partner.reservations.find params.require(:id)

    authorize! :destroy, @reservation
    @reservation.destroy
  end

  def approve
    @partner = User.partners.find params.require(:user_id)
    authorize! :show, @partner
    @reservation = @partner.reservations.find params.require(:id)
    authorize! :change_status, @reservation


    @reservation.disapproval_message = nil
    @reservation.status = :approved
    @reservation.save
  end

  def disapprove
    @partner = User.partners.find params.require(:user_id)
    authorize! :show, @partner
    @reservation = @partner.reservations.find params.require(:disapprove).require(:id)
    authorize! :change_status, Reservation

    if params.require(:disapprove)[:reason].blank?
      flash.now[:error] = "Please enter a reason."
    else
      @reservation.status = :disapproved
      @reservation.disapproval_message = params.require(:disapprove).require(:reason)
      @reservation.save
    end

  end

  private
  def reservation_params
    params.require(:reservation).permit(:count)
  end
end
