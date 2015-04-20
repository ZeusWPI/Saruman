# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  email      :string(255)
#  deadline   :datetime
#  name       :string(255)
#

require 'test_helper'

class SettingsTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
