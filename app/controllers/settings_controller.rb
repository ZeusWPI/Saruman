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
    params.require(:settings).permit(:organisation_name, :address, :event_name, :email, :special_requests_email,
                                     :deadline, :event_date, :show_pickup_columns_in_reservations)
  end
end
