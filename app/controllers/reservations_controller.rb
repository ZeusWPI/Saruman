class ReservationsController < ApplicationController
  before_action :authenticate_user!

  # Sets the current_user taking the action so paper trail versions have their
  # whodunnit set
  before_action :set_paper_trail_whodunnit

  def index
    @partner = User.partners.includes(reservations: :item).find params.require(:user_id)
    authorize! :show, @partner
  end

  def history
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

    unless @reservation.save
      @show_validations = true
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @partner = User.partners.find params.require(:user_id)

    @reservation = @partner.reservations.find params.require(:id)
    authorize! :update, @reservation
  end

  def update
    @partner = User.partners.find params.require(:user_id)
    authorize! :show, @partner

    @reservation = @partner.reservations.find params.require(:id)
    authorize! :update, @reservation

    unless @reservation.update(reservation_params)
      @show_validations = true
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @partner = User.partners.find params.require(:user_id)
    authorize! :show, @partner
    @reservation = @partner.reservations.find params.require(:id)

    authorize! :destroy, @reservation
    @reservation.destroy
  end

  def summary
    @partner = User.partners.includes(reservations: :item).find params.require(:user_id)
    authorize! :show, @partner
  end

  def approve
    @partner = User.partners.find params.require(:user_id)
    authorize! :show, @partner
    @reservation = @partner.reservations.find params.require(:id)
    authorize! :change_status, @reservation

    # If there already is an approved item with the same id; merge these
    @duplicate = @partner.reservations.approved.find_by(item_id: @reservation.item_id)
    if @duplicate.nil?
      @reservation.disapproval_message = nil
      @reservation.status = :approved
      @reservation.save
    else
      @duplicate.count += @reservation.count
      @duplicate.save
      @reservation.destroy
    end
  end

  def approve_all
    @partner = User.partners.find params.require(:user_id)
    authorize! :show, @partner
    @reservations = @partner.reservations.pending

    unless @reservations.empty?
      authorize! :change_status, @reservations.first
      @reservations.map(&:approve)
    end

    flash[:success] = "Approved!"
    redirect_to @partner
  end

  def disapprove
    @partner = User.partners.find params.require(:user_id)
    authorize! :show, @partner
    @reservation = @partner.reservations.find params.require(:disapprove).require(:id)
    authorize! :change_status, Reservation
  end

  def disapproved
    @partner = User.partners.find params.require(:user_id)
    authorize! :show, @partner
    @reservation = @partner.reservations.find params.require(:disapprove).require(:id)
    authorize! :change_status, Reservation

    if params.require(:disapprove)[:reason].blank?
      flash[:error] = "Please enter a reason for disapproval."
      render :new, status: :unprocessable_entity
    else
      @reservation.status = :disapproved
      @reservation.disapproval_message = params.require(:disapprove).require(:reason)
      @reservation.save
    end
  end

  def revert
    authorize! :manage, :all

    @reservation = Reservation.find params.require(:id)
    @option = params[:option]&.to_sym || :out

    # If the previous version is nil; there was a force create
    if @reservation.paper_trail.previous_version.nil?
      # Delete it
      @reservation.destroy
    else
      # Restore the previous version
      @reservation = @reservation.paper_trail.previous_version
      @reservation.save
    end

    flash[:notice] = "Scan has been reverted."

    redirect_to scan_path(option: @option)
  end

  private

  def reservation_params
    params.require(:reservation).permit(:count)
  end
end
