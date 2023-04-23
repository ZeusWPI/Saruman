# == Schema Information
#
# Table name: items
#
#  id                       :bigint           not null, primary key
#  name                     :string(255)
#  description              :string(255)
#  price                    :integer
#  created_at               :datetime
#  updated_at               :datetime
#  quantity                 :integer
#  barcode                  :string(255)
#  barcode_data             :string(255)
#  barcode_img_file_name    :string(255)
#  barcode_img_content_type :string(255)
#  barcode_img_file_size    :bigint
#  barcode_img_updated_at   :datetime
#  category                 :integer
#  deposit                  :integer
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
