require 'test_helper'

class ItemsHelperTest < ActionView::TestCase
  test "item without price displays correctly" do
    item = Item.drank.create!(name: "TestItem", price: 0)

    assert_equal item.to_s, "TestItem - €0.00 - (€0.00)"
  end

  test "item with price displays correctly" do
    item = Item.drank.create!(name: "TestItem", price: 10)

    assert_equal item.to_s, "TestItem - €10.00 - (€0.00)"
  end

  test "item with price and deposit displays correctly" do
    item = Item.drank.create!(name: "TestItem", price: 10, deposit: 5)

    assert_equal item.to_s, "TestItem - €10.00 - (€5.00)"
  end

  test "item with description, price and deposit displays correctly" do
    item = Item.drank.create!(name: "TestItem", description: "Blargh", price: 10, deposit: 5)

    assert_equal item.to_s, "TestItem - Blargh - €10.00 - (€5.00)"
  end
end
