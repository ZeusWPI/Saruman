class PartnerMailer < ApplicationMailer
  before_action :assert_settings_complete

  def send_token(partner)
    @partner = partner
    mail to: "#{partner.name} <#{partner.email}>", subject: "[Saruman] Login token for #{partner.name}"
  end

  def send_barcode(partner)
    @partner = partner

    calculated_barcode = Barby::EAN13.new(partner.barcode_data)
    attachments.inline['barcode.png'] = calculated_barcode.to_png(xdim: 3)

    mail to: "#{partner.name} <#{partner.email}>", subject: "[Saruman] Scanpost barcode for #{partner.name}"
  end

  def send_bill(partner)
    @partner = partner

    pdf = GenerateBillingProposal.new(partner).call
    attachments['billing_proposal.pdf'] = pdf

    mail to: "#{partner.name} <#{partner.email}>", subject: "[Saruman] Bill for #{partner.name}"
  end

  private

  def assert_settings_complete
    raise Settings::SettingsNotCompleteError unless Settings.instance.complete?
  end
end
