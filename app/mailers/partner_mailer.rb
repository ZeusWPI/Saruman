class PartnerMailer < ActionMailer::Base
  default from: "noreply@zeus.ugent.be"

  def send_token(partner)
    @partner = partner
    mail to: "#{partner.name} <#{partner.email}>", subject: "Saruman token for #{partner.name}"
  end

  def send_barcode(partner)
    @partner = partner

    barcode = Barcodes.create('EAN13', data: partner.barcode_data, bar_width: 35, bar_height: 1500, caption_height: 300, caption_size: 275 ) # required: height > size
    attachments.inline['barcode.png'] = Barcodes::Renderer::Image.new(barcode).render

    mail to: "#{partner.name} <#{partner.email}>", subject: "Scanpost barcode for #{partner.name}"
  end
end
