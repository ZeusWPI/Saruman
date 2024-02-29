# == Schema Information
#
# Table name: settings
#
#  id                                  :integer          not null, primary key
#  deadline                            :datetime
#  email                               :string
#  event_date                          :date             default(Thu, 29 Feb 2024), not null
#  event_name                          :string
#  organisation_name                   :string           default(""), not null
#  show_pickup_columns_in_reservations :boolean          default(FALSE), not null
#  created_at                          :datetime
#  updated_at                          :datetime
#

require 'test_helper'

class SettingsTest < ActiveSupport::TestCase
  test "expired? to return correct value" do
    Settings.instance.update!(deadline: nil)
    assert_not Settings.instance.expired?

    Settings.instance.update!(deadline: DateTime.current - 10.minutes)
    assert Settings.instance.expired?

    Settings.instance.update!(deadline: DateTime.current + 10.minutes)
    assert_not Settings.instance.expired?
  end
end
