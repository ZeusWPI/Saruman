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
      @partner = User.partners.find_by_barcode params.require(:scan)[:partner_code]
      @item = Item.find_by_barcode params.require(:scan)[:item_code]

      if @partner and @item
        process_check
      else
        flash.now[:error] = "The item or partner does not exist."
      end

    end

    render action: :scan
  end

  private

  def process_check
    @count = params.require(:scan)[:count]

    if params.require(:scan)[:options] == "in"
      check_in params.require(:scan)
    else
      check_out params.require(:scan)
    end
  end

  def blanks(params)
    params.require(:scan)[:partner_code].blank? or params.require(:scan)[:item_code].blank? or params.require(:scan)[:count].blank?
  end

  def check_in(params)
    flash.now[:notice] = "Checking in!"
  end

  def check_out(params)
    flash.now[:notice] = "Checking out!"
  end

end
