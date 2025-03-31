class ApplicationMailer < ActionMailer::Base
  default from: "saruman@zeus.ugent.be"

  helper ApplicationHelper

  before_action :assert_settings_complete

  private

  def assert_settings_complete
    raise Settings::SettingsNotCompleteError unless Settings.instance.complete?
  end
end
