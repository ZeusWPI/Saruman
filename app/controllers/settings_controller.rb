class SettingsController < ApplicationController
  def index
    @settings = Settings.instance
  end

  def update
    @settings = Settings.instance
    @settings.update settings_params

    render :index
  end

  private

  def settings_params
    params.require(:settings).permit(:organisation_name, :event_name, :email, :deadline)
  end
end
