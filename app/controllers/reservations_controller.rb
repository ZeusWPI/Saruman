class ReservationsController < ApplicationController
  before_action :authenticate_user!

  respond_to :html, :js

  def index
    @partner = User.partners.find params.require(:user_id)

    authorize! :show, @partner

    @reservations = @partner.reservations.includes(:item)
  end

  def overview
    authorize! :manage, Reservation
    @reservations = Reservation.approved.group(:item).sum(:count)
    @total_quantity = Reservation.approved.sum(:count)
    @total_price = Reservation.approved.joins(:item).sum("reservations.count*items.price/100.0")

    @total_reservations = Reservation.approved.count
    @per_partner = Reservation.approved.joins(:item).joins(:user).group(:user).sum("items.price*reservations.count/100.0")
    @per_partner.merge!(Reservation.approved.joins(:user).group(:user).count) {|h,nv,ov| [nv,ov]}
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

    # If there already is an approved item with the same id; merge these
    @duplicate = @partner.reservations.approved.find_by_item_id @reservation.item_id
    unless @duplicate.nil?
      @duplicate.count += @reservation.count
      @duplicate.save
      @reservation.destroy
    else
      @reservation.disapproval_message = nil
      @reservation.status = :approved
      @reservation.save
    end

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
