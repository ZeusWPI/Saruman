require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

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
    get :show, params: { id: @item }
    assert_response :success
  end

  test "should create item" do
    assert_difference 'Item.count', +1 do
      post :create, xhr: true, params: { item: { name: "Toolbox", description: "A generic toolbox",
                                  category: "materiaal", price: 35 } }
    end

    assert_response :success
  end

  test "should get edit" do
    get :edit, xhr: true, params: { id: @item }

    assert_response :success
  end

  test "should update item" do
    put :update, xhr: true, params: { id: @item, item: { description: @item.description, name: @item.name, price: @item.price } }

    assert_response :success
  end

  test "should destroy item" do
    assert_difference 'Item.count', -1 do
      get :destroy, xhr: true, params: { id: @item }
    end

    assert_response :success
  end

  test "should not destroy reversed item" do
    assert_difference 'Item.count', 0 do
      get :destroy, xhr: true, params: { id: items(:vat) }
    end

    assert_response :success
  end
end
