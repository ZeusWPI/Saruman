# == Schema Information
#
# Table name: items
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  description  :string(255)
#  price        :integer
#  created_at   :datetime
#  updated_at   :datetime
#  quantity     :integer
#  barcode      :string(255)
#  barcode_data :string(255)
#

require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  verify_fixtures Item
  # test "the truth" do
  #   assert true
  # end
end
