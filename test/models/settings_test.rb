# == Schema Information
#
# Table name: settings
#
#  id                :bigint           not null, primary key
#  created_at        :datetime
#  updated_at        :datetime
#  email             :string(255)
#  deadline          :datetime
#  event_name        :string(255)
#  organisation_name :string(255)      default(""), not null
#

require 'test_helper'

class SettingsTest < ActiveSupport::TestCase
  test "expired? to return correct value" do
    Settings.instance.update_attributes deadline: nil
    assert_not Settings.instance.expired?

    Settings.instance.update_attributes deadline: DateTime.now + 10.minutes
    assert_not Settings.instance.expired?

    Settings.instance.update_attributes deadline: DateTime.now - 10.minutes
    assert Settings.instance.expired?
  end
end
