class PartnersController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource only: [:index, :send_unsent_tokens, :send_all_tokens]
  before_action :set_partner, only: [:edit, :update, :destroy,
                                     :send_barcode,
                                     :billing, :download_bill, :send_bill,
                                     :scan, :process_scan]

  def index
    @partners = Partner.ordered_by_name
  end

  def new
    @partner = Partner.new
  end

  def edit
    authorize! :update, @partner
  end

  def create
    @partner = Partner.new(new_partner_params) do |p|
      p.users.sole.password = Devise.friendly_token
    end

    if @partner.save
      flash.now[:success] = "Partner #{@partner.name} created!"
    else
      @show_validations = true
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @partner

    if @partner.update(partner_params)
      flash.now[:success] = "Partner #{@partner.name} updated!"
    else
      @show_validations = true
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @partner

    flash.now[:success] = "Partner #{@partner.name} is removed!"

    @partner.destroy!
  end

  def send_unsent_tokens
    authorize! :read, @partner

    @partner.users.where(sent: false).find_each(&:send_token)

    flash.now[:success] = "Sent unsent login links for #{@partner.name}!"
  end

  def send_barcode
    authorize! :read, @partner

    @partner.send_barcode

    flash.now[:success] = "Barcode sent to #{@partner.name}!"
  end

  def download_bill
    authorize! :read, :partner

    pdf = GenerateBillingProposal.new(@partner).call
    send_data pdf, filename: 'billing_proposal.pdf', type: 'application/pdf'
  end

  def send_bill
    authorize! :read, :partner

    PartnerMailer.send_bill(@partner).deliver_now

    flash[:notice] = "Billing proposal sent!"

    redirect_to action: :billing
  end

  def billing; end

  def scan
    authorize! :manage, :partner

    @scan = Scan.new partner: @partner
    @scan.fill_scan_items
  end

  def process_scan
    @scan = Scan.new scan_params
    if @scan.save
      flash[:notice] = "#{@partner.name} #{@scan.notification}."
      redirect_to partners_path
    else
      render :scan
    end
  end

  def excel
    authorize! :manage, Reservation
    @reservations = Reservation.joins(:item).joins(:partner).group_by(&:partner)

    respond_to do |format|
      format.xlsx
    end
  end

  rescue_from Settings::SettingsNotCompleteError do
    flash[:error] = "Fill in the Application Settings first."
    redirect_to action: :index
  end

  private

  def partner_params
    params.require(:partner).permit(:name)
  end

  def new_partner_params
    params.require(:partner).permit(:name, users_attributes: [:name, :email])
  end

  def scan_params
    params.require(:scan).permit(scan_items_attributes: [:reservation, :pick_up, :return_used, :return_unused]).merge({ partner: @partner })
  end

  def set_partner
    @partner = Partner.find(params.require(:id))
  end
end
