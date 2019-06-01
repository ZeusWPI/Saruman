require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

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
    get :show, params: { id: @user }
    assert_response :success
    assert_not_nil assigns(:partner)
  end

  test "should show user for partners" do
    sign_out users(:tom)
    sign_in users(:vtk)

    get :show, params: { id: users(:vtk) }
    assert_response :success
    assert_not_nil assigns(:partner)
  end

  test "shouldnt show other user for partners" do
    sign_out users(:tom)
    sign_in users(:vtk)

    get :show, params: { id: users(:hilok) }
    assert_response :redirect
  end

  test "should show warning for partners after deadline" do
    Settings.instance.update_attributes! deadline: DateTime.now - 1

    sign_out users(:tom)
    sign_in users(:vtk)

    get :show, params: { id: users(:vtk) }
    assert_response :success
    assert_not_nil assigns(:partner)
    assert_match(/The deadline for reservations/, response.body)
    assert_select "table-responsive form", false
  end

  test "dont show warning for admins after deadline" do
    Settings.instance.update_attributes! deadline: DateTime.now - 1

    get :show, params: { id: users(:vtk) }
    assert_response :success
    assert_not_nil assigns(:partner)
    assert_no_match(/The deadline for reservations/, response.body)
    assert_select "form"
  end

  test "should create user" do
    assert_difference 'User.count', +1 do
      post :create, xhr: true, params: { user: { name: "Zeus", email: "zeus@zeus.zeus" } }
    end

    assert_response :success
  end

  test "should get edit" do
    get :edit, xhr: true, params: { id: @user }

    assert_response :success
  end

  test "should update user" do
    patch :update, params: { id: @user, user: { name: "Zeus", email: "zeus@email.com" } }

    assert user_path(assigns(:partner))
  end

  test "should destroy user" do
    assert_difference 'User.count', -1 do
      get :destroy, xhr: true, params: { id: @user }
    end

    assert_response :success
  end

  test "should get resend" do
    assert_difference "ActionMailer::Base.deliveries.size", +1 do
      get :resend, xhr: true, params: { id: @user }
    end

    assert_response :success
  end

  test "test process multiple scans" do
    post :process_scan, params: {
      id: users(:vtk), scan: { scan_items_attributes: {
        "0": { reservation: reservations(:vtk_tent), pick_up: 1 },
        "1": { reservation: reservations(:vtk_stoel_approved), pick_up: 2 }
      } }
    }

    assert_equal 1, reservations(:vtk_tent).reload.picked_up_count
    assert_equal 2, reservations(:vtk_stoel_approved).reload.picked_up_count
  end

  test "should be successful" do
    post :process_scan, params: {
      id: users(:vtk), scan: { scan_items_attributes: {
        "0": { reservation: reservations(:vtk_tent), pick_up: 1 },
        "1": { reservation: reservations(:vtk_stoel_approved), pick_up: 2 }
      } }
    }

    assert_response :redirect
    assert_no_match(/picked up/, response.body)
    assert_no_match(/tent/, response.body)
    assert_no_match(/stoel/, response.body)
  end

end
