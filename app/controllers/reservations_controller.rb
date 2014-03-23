class ReservationsController < ApplicationController

  before_action :authenticate_partner!, except: [:approve, :disapprove, :show]
  before_action :authenticate_user!, only: [:approve, :disapprove], expect: [:show]

  respond_to :html, :js

  def index
    @partner = Partner.find params.require(:partner_id)

    authorize! :read, @partner

    @reservations = @partner.reservations

    @price = 0
    @reservations.each { |r| @price += r.count*r.item.price }
  end

  def show
    @partner = Partner.find params.require(:partner_id)
    @reservation = @partner.reservations.find params.require(:id)
  end

  def create
    @partner = Partner.find params.require(:partner_id)
    authorize! :read, @partner
    authorize! :create, Reservation

    item = Item.find params.require(:reservation).require(:item_id)

    @reservation = @partner.reservations.new reservation_params
    @reservation.item = item
    @reservation.save

    respond_with @reservation
  end

  def edit
    @partner = Partner.find params.require(:partner_id)

    @reservation = @partner.reservations.find params.require(:id)
    respond_with @reservation
  end

  def update
    @partner = Partner.find params.require(:partner_id)

    @reservation = @partner.reservations.find params.require(:id)
    @reservation.update reservation_params
    respond_with @reservation
  end

  def destroy
    @partner = Partner.find params.require(:partner_id)

    @reservation = @partner.reservations.find params.require(:id)
    @reservation.destroy
  end

  def approve
    @partner = Partner.find params.require(:partner_id)
    @reservation = @partner.reservations.find params.require(:id)
    authorize! :change_status, Reservation

    @reservation.status = :approved
    @reservation.save
  end

  def disapprove
    @partner = Partner.find params.require(:partner_id)
    @reservation = @partner.reservations.find params.require(:id)
    authorize! :change_status, Reservation

    @reservation.status = :disapproved
    @reservation.save
  end

  private
  def reservation_params
    params.require(:reservation).permit(:count)
  end
end
