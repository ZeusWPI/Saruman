class PartnerMailer < ActionMailer::Base
  default from: "noreply@zeus.ugent.be"
  helper ApplicationHelper

  def send_token(partner)
    @partner = partner
    mail to: "#{partner.name} <#{partner.email}>", subject: "Saruman token for #{partner.name}"
  end

  def send_barcode(partner)
    @partner = partner

    calculated_barcode = Barby::EAN13.new(partner.barcode_data)
    attachments.inline['barcode.png'] = calculated_barcode.to_png(xdim: 3)

    mail to: "#{partner.name} <#{partner.email}>", subject: "Scanpost barcode for #{partner.name}"
  end

  def send_bill partner
    @partner = partner
    @reservations = @partner.reservations.approved

    pdf = WickedPdf.new.pdf_from_string(render_to_string pdf: 'bill.pdf', template: 'users/send_bill.pdf.erb', layout: false)
    attachments['bill.pdf'] = pdf

    mail to: "#{partner.name} <#{partner.email}>", subject: "Bill for #{partner.name}"
  end
end
