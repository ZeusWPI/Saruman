# == Schema Information
#
# Table name: partners
#
#  id           :bigint           not null, primary key
#  barcode      :string           not null
#  barcode_data :string           not null
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_partners_on_name  (name) UNIQUE
#

require 'test_helper'

class PartnerTest < ActiveSupport::TestCase
  verify_fixtures Partner

  test "should generate barcode" do
    p = Partner.create!(name: "Test")

    assert_not_nil p.barcode
    assert_not_nil p.barcode_data
  end
end
