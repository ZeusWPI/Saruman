class PartnersController < ApplicationController
  before_filter :authenticate_user!

  def new
    @partner = Partner.new
  end

  def create
    @partner = Partner.new partner_params

    if @partner.save
      redirect_to partners_path
    else
      render :new
    end
  end

  def index
    @partners = Partner.all
  end

  def barcodes
    @barcodes = Partner.all
    render 'barcodes/barcodes'
  end

  def show
    @partner = User.partners.includes(reservations: :item).find params.require(:id)
    authorize! :show, @partner
  end

  def edit
    authorize! :update, @partner

    respond_with @partner
  end

  def update
    authorize! :update, @partner

    @partner.update partner_params

    respond_with @partner
  end


  def resend
    authorize! :read, @partner

    @partner.send_token
  end

  def send_barcode
    authorize! :read, @partner

    @partner.send_barcode
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



  private

  def partner_params
    params.require(:partner).permit(:name, :email)
  end

  def scan_params
    params.require(:scan).permit(scan_items_attributes: [ :reservation, :pick_up, :bring_back ]).merge({ partner: @partner })
  end

  def set_partner
    @partner = User.partners.find params.require(:id)
  end
end
