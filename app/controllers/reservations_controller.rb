class ReservationsController < ApplicationController
  acts_as_token_authentication_handler_for Partner

  respond_to :html, :js

  def index
    @partner = Partner.find params.require(:partner_id)

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

  private
  def reservation_params
    params.require(:reservation).permit(:count)
  end
end
