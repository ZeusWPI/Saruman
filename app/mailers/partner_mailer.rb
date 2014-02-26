class PartnerMailer < ActionMailer::Base
  default from: "noreply@zeus.ugent.be"

  def send_token(partner)
    @partner = partner
    mail to: "#{partner.name} <#{partner.email}>", subject: "Saruman token for #{partner.name}"
  end
end
