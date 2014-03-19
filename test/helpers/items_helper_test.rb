require 'test_helper'

class ItemsHelperTest < ActionView::TestCase

  test "item without price displays correctly" do
    item = Item.new
    item.name = "TestItem"
    item.price = 0

    assert_equal item.name_with_price, "TestItem"
  end

  test "item with price displays correctly" do
    item = Item.new
    item.name = "TestItem"
    item.price = 10

    assert_equal item.name_with_price, "#{item.name} - €#{'%0.2f' % item.price}"
  end
end
