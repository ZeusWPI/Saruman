class ScanController < ApplicationController
  before_action :authenticate_user!

  def scan
    authorize! :manage, :all

    @option = params[:option]&.to_sym || :out
  end

  def check
    authorize! :manage, :all

    @option = params.require(:scan)[:options].to_sym

    if blanks?(params)
      flash[:error] = "Please fill in all fields."
      redirect_to action: :scan, option: @option
      return
    end

    @partner = Partner.find_by(id: params.require(:scan)[:partner])
    @item = Item.find_by(id: params.require(:scan)[:item])

    if @partner and @item
      process_check
    else
      flash[:error] = "The item or partner does not exist."
      redirect_to action: :scan, option: @option
    end
  end

  def force
    authorize! :manage, :all

    @partner = Partner.find_by(id: params.require(:force)[:partner_id])
    @item = Item.find_by(id: params.require(:force)[:item_id])
    @count = params.require(:force)[:count].to_i
    @option = params.require(:force)[:options]&.to_sym || :out

    # Get the approved item, if any
    @reservation = @partner.reservations.approved.find_by(item_id: @item.id)
    if @reservation
      # Item found: increase and picked up count
      flash[:notice] = "Increased the existing reservation with #{@reservation.picked_up_count + @count - @reservation.count}x #{@item.name}. #{view_context.link_to 'Revert this', revert_partner_reservation_path(@partner, @reservation, option: @option)}."

      @reservation.count = @reservation.picked_up_count + @count
      @reservation.picked_up_count = @reservation.picked_up_count + @count
      @reservation.save
    else
      @reservation = @partner.reservations.new
      @reservation.count = @count
      @reservation.picked_up_count = @count
      @reservation.item = @item
      @reservation.status = :approved
      @reservation.save

      # No approved reservation for this item: add a new one
      flash[:notice] = "Created a new reservation for #{@count}x #{@item.name}. #{view_context.link_to 'Revert this', revert_partner_reservation_path(@partner, @reservation, option: @option)}."
    end

    redirect_to action: :scan, option: @option
  end

  private

  def process_check
    @count = params.require(:scan)[:count].to_i

    if @option == :out
      check_out params.require(:scan)
    else
      check_in params.require(:scan)
      redirect_to action: :scan, option: @option
    end
  end

  def check_in(params)
    # Get the reservation, if any
    reservation = @partner.reservations.approved.find_by(item_id: @item.id)

    if reservation
      if @option == :return_unused
        reservation.returned_unused_count += @count
      elsif @option == :return_used
        reservation.returned_used_count += @count
      else
        raise "Option #{@option} not supported."
      end

      reservation.save!

      # Notice the partner how many items he has left
      flash[:notice] = "#{@partner.name} brought back #{@count}x #{@item.name}. They have #{reservation.picked_up_count - reservation.returned_count}x #{@item.name} remaining in their possession. #{view_context.link_to 'Revert this checkin', revert_partner_reservation_path(@partner, reservation, option: @option)}."
    else
      # No reservations: display a warning
      flash[:warning] = "#{@partner.name} does not has a reservation for this item."
    end
  end

  def check_out(params)
    # Get the reservation, if any
    @reservation = @partner.reservations.approved.find_by(item_id: @item.id)
    if @reservation
      # If there is a reservation, check if he is allowed to pick up this amount
      # of new items
      if @reservation.count < @reservation.picked_up_count + @count
        # If the new amount of picked up items exceeds the amount he has
        # reserved, enable the force on the page
        @display_force = true
        render action: :scan
      else
        # Else, let him pick up these items
        @reservation.picked_up_count += @count
        @reservation.save

        # Notice the partner how many items he is allowed to pick up
        flash[:success] = "#{@partner.name} picked up #{@count}x #{@item.name}. They have still #{@reservation.count - @reservation.picked_up_count}x #{@item.name} remaining to pick up. #{view_context.link_to 'Revert this checkout', revert_partner_reservation_path(@partner, @reservation, option: @option)}."
        redirect_to action: :scan
      end
    else
      # No reservation: show the force form on the scan page
      @display_force = true
      render action: :scan
    end
  end

  def blanks?(params)
    params.require(:scan)[:partner].blank? or params.require(:scan)[:item].blank? or params.require(:scan)[:count].blank?
  end
end
