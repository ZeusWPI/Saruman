class PartnerMailer < ApplicationMailer
  def send_barcode(partner)
    @partner = partner

    calculated_barcode = Barby::EAN13.new(partner.barcode_data)
    attachments.inline['barcode.png'] = calculated_barcode.to_png(xdim: 3)

    mail to: partner_users_with_names(partner), subject: "[Saruman] Scanpost barcode for #{partner.name}"
  end

  def send_bill(partner)
    @partner = partner

    pdf = GenerateBillingProposal.new(partner).call
    attachments['billing_proposal.pdf'] = pdf

    mail to: partner_users_with_names(partner), subject: "[Saruman] Bill for #{partner.name}"
  end

  private

  def partner_users_with_names(partner)
    partner.users.map { |u| email_address_with_name(u.email, u.name) }
  end
end
