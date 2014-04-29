class UsersController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :js

  def index
    @partners = User.partners

    authorize! :read, User
  end

  def show
    @partner = User.partners.includes(reservations: :item).find params.require(:id)

    authorize! :show, @partner
  end

  def create
    authorize! :create, User

    @partner = User.new partner_params
    @partner.role = "partner"
    @partner.password = (0...8).map { (65 + rand(26)).chr }.join
    @partner.save

    respond_with @partner
  end

  def edit
    @partner = User.partners.find params.require(:id)
    authorize! :update, @partner

    respond_with @partner
  end

  def update
    @partner = User.partners.find params.require(:id)
    authorize! :update, @partner

    @partner.update partner_params

    respond_with @partner
  end

  def destroy
    @partner = User.partners.find params.require(:id)
    authorize! :destroy, @partner

    @partner.destroy
  end

  def resend
    @partner = User.partners.find params.require(:id)
    authorize! :read, @partner

    @partner.send_token
  end

  def send_barcode
    @partner = User.partners.find params.require(:id)
    authorize! :read, @partner

    @partner.send_barcode
  end

  def get_barcode
    @partner = User.partners.find params.require(:id)
    authorize! :show, @partner

    barcode = Barcodes.create('EAN13', data: @partner.barcode_data, bar_width: 35, bar_height: 1500, caption_height: 300, caption_size: 275 ) # required: height > size
    barcode_pdf = Barcodes::Renderer::Pdf.new(barcode).render

    send_data barcode_pdf, :filename => "barcode.pdf", :type => "application/pdf"
  end

  private
  def partner_params
    params.require(:user).permit(:name, :email)
  end

end
