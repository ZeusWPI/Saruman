# == Schema Information
#
# Table name: items
#
#  id           :integer          not null, primary key
#  barcode      :string
#  barcode_data :string
#  category     :integer
#  deposit      :integer          default(0)
#  description  :string
#  name         :string
#  price        :integer
#  quantity     :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  verify_fixtures Item

  test "should generate barcode" do
    i = Item.create!(name: 'Ding', category: :materiaal, price: 0, deposit: 0)

    assert_not_nil i.barcode
    assert_not_nil i.barcode_data
  end
end
