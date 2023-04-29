class ReportsController < ApplicationController
  layout 'reports'

  before_action :authenticate_user!

  def index
    redirect_to action: :items
  end

  def items
    authorize! :manage, Reservation
    @approved_reservations = Reservation.ordered_by_item_name.approved
  end

  def partners
    @approved_reservations = Reservation.ordered_by_item_name.approved
  end

  def item_barcodes

  end

  def partner_barcodes

  end
end
