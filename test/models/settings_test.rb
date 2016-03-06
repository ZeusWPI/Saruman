# == Schema Information
#
# Table name: settings
#
#  id                :integer          not null, primary key
#  created_at        :datetime
#  updated_at        :datetime
#  email             :string(255)
#  deadline          :datetime
#  event_name        :string(255)
#  organisation_name :string           default(""), not null
#

require 'test_helper'

class SettingsTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
