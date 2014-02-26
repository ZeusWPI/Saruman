class PartnercentersController < ApplicationController
  before_filter :authenticate_partner_from_token!
  before_filter :authenticate_partner!

  def sign_in
    redirect_to action: :show
  end

  def show
  end

  private

  # For this example, we are simply using token authentication
  # via parameters. However, anyone could use Rails's token
  # authentication features to get the token from a header.
  def authenticate_partner_from_token!
    # Set the authentication token params if not already present,
    # see http://stackoverflow.com/questions/11017348/rails-api-authentication-by-headers-token
    if partner_token = params[:partner_token].blank? && request.headers["X-Partner-Token"]
      params[:partner_token] = partner_token
    end
    if partner_email = params[:partner_email].blank? && request.headers["X-Partner-Email"]
      params[:partner_email] = partner_email
    end

    partner_email = params[:partner_email].presence
    # See https://github.com/ryanb/cancan/blob/1.6.10/lib/cancan/controller_resource.rb#L108-L111
    if Partner.respond_to? "find_by"
      partner = partner_email && Partner.find_by(email: partner_email)
    elsif Partner.respond_to? "find_by_email"
      partner = partner_email && Partner.find_by_email(partner_email)
    end

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if partner && Devise.secure_compare(partner.authentication_token, params[:partner_token])
      # Notice we are passing store false, so the partner is not
      # actually stored in the session and a token is needed
      # for every request. If you want the token to work as a
      # sign in token, you can simply remove store: false.
      sign_in partner, store: false
    end
  end

end
