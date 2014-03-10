require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @item = items(:one)
    sign_in users(:tom)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:items)
  end

  test "should create item" do
    assert_difference('Item.count') do
      post :create, item: { description: @item.description, name: @item.name, price: @item.price }
    end

    assert_redirected_to item_path(assigns(:item))
  end

  test "should show item" do
    get :show, id: @item
    assert_response :success
  end

  test "should update item" do
    patch :update, id: @item, item: { description: @item.description, name: @item.name, price: @item.price }
    assert_redirected_to item_path(assigns(:item))
  end
end
