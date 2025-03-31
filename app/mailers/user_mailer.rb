class UserMailer < ApplicationMailer
  def send_token(user)
    @user = user
    mail to: email_address_with_name(user.email, user.name), subject: "[Saruman] Login token for #{user.name} (#{user.partner.name})"
  end
end
