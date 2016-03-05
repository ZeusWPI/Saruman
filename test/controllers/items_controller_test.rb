require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @item = items(:brood)
    sign_in users(:tom)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:items)
  end

  test "should show item" do
    get :show, id: @item
    assert_response :success
  end

  test "should create item" do
    assert_difference 'Item.count', +1 do
      xhr :post, :create, item: { name: "Toolbox", description: "A generic toolbox",
                                  category: "materiaal", price: 35 }
    end

    assert_response :success
  end

  test "should get edit" do
    xhr :get, :edit, id: @item

    assert_response :success
  end

  test "should update item" do
    patch :update, id: @item, item: { description: @item.description, name: @item.name, price: @item.price }

    assert_redirected_to item_path(assigns(:item))
  end

  test "should destroy item" do
    assert_difference 'Item.count', -1 do
      xhr :get, :destroy, id: @item
    end

    assert_response :success
  end

  test "should not destroy reversed item" do
    assert_difference 'Item.count', 0 do
      xhr :get, :destroy, id: items(:vat)
    end

    assert_response :success
  end
end
