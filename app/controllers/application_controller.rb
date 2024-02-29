class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_action :store_location

  # Allows us to always replace the flash turbo frame when flashes are triggered
  layout -> { "turbo_rails/frame" if turbo_frame_request? }

  def store_location
    # store last url as long as it isn't a /users path
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_path
  end

  rescue_from Settings::SettingsNotCompleteError do
    flash[:error] = "Fill in the Application Settings first."
    redirect_to root_path
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end
end
