class SettingsController < ApplicationController
  def show
    authorize! :manage, Settings
    @settings = Settings.instance
  end

  def update
    authorize! :manage, Settings
    @settings = Settings.instance
    @settings.update settings_params

    flash[:success] = "Settings updated successfully!"

    redirect_to action: :show
  end

  private

  def settings_params
    params.require(:settings).permit(:organisation_name, :event_name, :email, :deadline)
  end
end
