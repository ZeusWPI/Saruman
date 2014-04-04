require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = users(:vtk)
    sign_in users(:tom)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:partners)
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
    assert_not_nil assigns(:partner)
  end

  test "should create user" do
    assert_difference 'User.count', +1 do
      xhr :post, :create, user: { name: "Zeus", email: "zeus@zeus.zeus" }
    end

    assert_response :success
  end

  test "should get edit" do
    xhr :get, :edit, id: @user

    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { name: "Zeus", email: "zeus@email.com" }

    assert user_path(assigns(:partner))
  end

  test "should destroy user" do
    assert_difference 'User.count', -1 do
      xhr :get, :destroy, id: @user
    end

    assert_response :success
  end

  test "should get resend" do
    assert_difference "ActionMailer::Base.deliveries.size", +1 do
      xhr :get, :resend, id: @user
    end

    assert_response :success
  end

end
