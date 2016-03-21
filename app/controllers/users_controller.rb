class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource only: [:index, :create]

  respond_to :html, :js

  before_action :set_partner, only: [:edit, :update, :destroy,
                                     :resend, :send_barcode,
                                     :get_barcode, :send_bill]

  def index
    @partners = @users.partners
  end

  def show
    @partner = User.partners.includes(reservations: :item).find params.require(:id)
    authorize! :show, @partner
  end

  def create
    @partner = @user
    @partner.role = "partner"
    @partner.password = (0...8).map { (65 + rand(26)).chr }.join
    @partner.save

    respond_with @partner
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

  def destroy
    authorize! :destroy, @partner

    @partner.destroy
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

  private

  def partner_params
    params.require(:user).permit(:name, :email)
  end
  alias_method :user_params, :partner_params

  def set_partner
    @partner = User.partners.find params.require(:id)
  end
end
