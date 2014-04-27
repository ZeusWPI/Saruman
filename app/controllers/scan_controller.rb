class ScanController < ApplicationController

  before_action :authenticate_user!

  respond_to :html, :js

  def scan
    authorize! :manage, :all
  end

  def check
    authorize! :manage, :all

    if blanks(params)
      flash.now[:error] = "Please fill in all fields."
    else
      @partner = User.partners.find_by_barcode(params.require(:scan)[:partner_code]) || User.partners.find_by_id(params.require(:scan)[:partner_id])
      @item = Item.find_by_id params.require(:scan)[:item_id]

      if @partner and @item
        process_check
      else
        flash.now[:error] = "The item or partner does not exist."
      end

    end

    render action: :scan
  end

  def force
    @partner = User.partners.find_by_id params.require(:force)[:partner_id]
    @item = Item.find_by_id params.require(:force)[:item_id]
    @count = params.require(:force)[:count].to_i

    # Get the approved item, if any
    @reservation = @partner.reservations.approved.find_by_item_id @item.id
    if @reservation
      # Item found: increase and picked up count
      flash.now[:notice] = "Increased the existing reservation with #{@reservation.picked_up_count + @count - @reservation.count}x #{@item.name}."

      @reservation.count = @reservation.picked_up_count + @count
      @reservation.picked_up_count = @reservation.picked_up_count + @count
      @reservation.save
    else
      # No approved reservation for this item: add a new one
      flash.now[:notice] = "Created a new reservation for #{@count}x #{@item.name}."

      @reservation = @partner.reservations.new
      @reservation.count = @count
      @reservation.picked_up_count = @count
      @reservation.item = @item
      @reservation.status = :approved
      @reservation.save
    end

    render action: :scan
  end

  private

  def process_check
    @count = params.require(:scan)[:count].to_i

    if params.require(:scan)[:options] == "in"
      check_in params.require(:scan)
    else
      check_out params.require(:scan)
    end
  end

  def blanks(params)
    (params.require(:scan)[:partner_code].blank? and params.require(:scan)[:partner_id].blank?) or params.require(:scan)[:item_id].blank? or params.require(:scan)[:count].blank?
  end

  def check_in(params)
    # Get the reservation, if any
    reservation = @partner.reservations.approved.find_by_item_id @item.id
    if reservation
      # If there is a reservation: increase the brought_back_count
      reservation.brought_back_count += @count
      reservation.save

      # Notice the partner how many items he has left
      flash.now[:notice] = "#{@partner.name} brought back #{@count}x #{@item.name}. He has #{reservation.picked_up_count - reservation.brought_back_count}x #{@item.name} remaining."
    else
      # No reservations: display a warning
      flash.now[:warning] = "#{@partner.name} does not have a reservation for this item."
    end
  end

  def check_out(params)
    # Get the reservation, if any
    @reservation = @partner.reservations.approved.find_by_item_id @item.id
    if @reservation
      # If there is a reservation, check if he is allowed to pick up this amount
      # of new items
      if @reservation.count < @reservation.picked_up_count + @count
        # If the new amount of picked up items exceeds the amount he has
        # reserved, enable the force on the page
        @display_force = true
      else
        # Else, let him pick up these items
        @reservation.picked_up_count += @count
        @reservation.save

        # Notice the partner how many items he is allowed to pick up
        flash.now[:notice] = "#{@partner.name} picked up #{@count}x #{@item.name}. He has still #{@reservation.count - @reservation.picked_up_count}x #{@item.name} remaining to pick up."
      end
    else
      # No reservation: show the force form on the scan page
      @display_force = true
    end
  end

end
