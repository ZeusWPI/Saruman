class ReservationsController < ApplicationController

  def index
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def reservation_params
    params.require(:reservation).permit(:item, :count)
  end
end
