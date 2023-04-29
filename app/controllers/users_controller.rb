class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource only: [:index, :create]

  before_action :set_partner, only: [:edit, :update, :destroy,
                                     :resend, :send_barcode,
                                     :get_barcode, :download_bill, :send_bill,
                                     :scan, :process_scan]

  def index
    @partners = @users.partners.ordered_by_name
  end

  def show
    @partner = User.partners.includes(reservations: :item).find params.require(:id)
    authorize! :show, @partner
  end

  def new
    @partner = User.partners.build
  end

  def create
    @partner = @user
    @partner.role = "partner"
    @partner.password = (0...8).map { (65 + rand(26)).chr }.join

    if @partner.save
      flash.now[:success] = "Partner #{@partner.name} created!"
    else
      @show_validations = true
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize! :update, @partner
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

    @partner.destroy
  end

  def resend
    authorize! :read, @partner

    @partner.send_token

    flash[:success] = "Sign in link sent to #{@partner.name} (#{@partner.email})"

    redirect_to action: :index
  end

  def send_barcode
    authorize! :read, @partner

    flash[:success] = "Barcode sent to #{@partner.name} (#{@partner.email})"

    @partner.send_barcode

    redirect_to action: :index
  end

  def get_barcode
    authorize! :show, @partner

    barcode = Barcodes.create('EAN13',
                              data: @partner.barcode_data,
                              bar_width: 35,
                              bar_height: 1500,
                              caption_height: 300,
                              caption_size: 275 ) # required: height > size
    barcode_pdf = Barcodes::Renderer::Pdf.new(barcode).render

    send_data barcode_pdf, filename: "barcode.pdf", type: "application/pdf"
  end

  def download_bill
    authorize! :read, :partner

    pdf = GenerateBillingProposal.new(@partner).call
    send_data pdf, filename: 'billing_proposal.pdf', type: 'application/pdf'
  end

  def send_bill
    authorize! :read, :partner

    PartnerMailer.send_bill(@partner).deliver_now
    redirect_to @partner, notice: "Bill sent"
  end

  def scan
    @scan = Scan.new partner: @partner
    @scan.fill_scan_items
  end

  def process_scan
    @scan = Scan.new scan_params
    if @scan.save
      flash[:notice] = "#{@partner.name} #{@scan.notification}."
      redirect_to users_path
    else
      render :scan
    end
  end

  def excel
    authorize! :manage, Reservation
    @reservations = Reservation.joins(:item).joins(:user).group_by(&:user)

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
    params.require(:user).permit(:name, :email)
  end
  alias_method :user_params, :partner_params

  def scan_params
    params.require(:scan).permit(scan_items_attributes: [ :reservation, :pick_up, :return_used, :return_unused ]).merge({ partner: @partner })
  end

  def set_partner
    @partner = User.partners.find params.require(:id)
  end
end
