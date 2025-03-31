require 'test_helper'

class PartnersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @partner = partners(:vtk)
    sign_in users(:tom)
  end

  test "should create partner" do
    assert_difference 'User.count', +1 do
      assert_difference 'Partner.count', +1 do
        post :create, xhr: true, params: { partner: { name: "Zeus", users_attributes: { '0': { name: "Zeus", email: "partner@zeus.gent" } } } }
      end
    end

    assert_response :success
  end

  test "should get edit" do
    get :edit, xhr: true, params: { id: @partner }

    assert_response :success
  end

  test "should update partner" do
    patch :update, xhr: true, params: { id: @partner, partner: { name: "Zeus" } }

    assert partner_path(assigns(:partner))
  end

  test "should destroy partner" do
    assert_difference 'Partner.count', -1 do
      get :destroy, xhr: true, params: { id: @partner }
    end

    assert_response :success
  end

  test "should get send unsent tokens" do
    assert_difference "ActionMailer::Base.deliveries.size", +1 do
      get :send_unsent_tokens, xhr: true, params: { id: @partner }
    end

    assert_response :success
  end

  test "test process multiple scans" do
    post :process_scan, params: {
      id: partners(:vtk), scan: { scan_items_attributes: {
        '0': { reservation: reservations(:vtk_tent), pick_up: 1 },
        '1': { reservation: reservations(:vtk_stoel_approved), pick_up: 2 }
      } }
    }

    assert_equal 1, reservations(:vtk_tent).reload.picked_up_count
    assert_equal 2, reservations(:vtk_stoel_approved).reload.picked_up_count
  end

  test "should be successful" do
    post :process_scan, params: {
      id: partners(:vtk), scan: { scan_items_attributes: {
        '0': { reservation: reservations(:vtk_tent), pick_up: 1 },
        '1': { reservation: reservations(:vtk_stoel_approved), pick_up: 2 }
      } }
    }

    assert_response :redirect
    assert_no_match(/picked up/, response.body)
    assert_no_match(/tent/, response.body)
    assert_no_match(/stoel/, response.body)
  end
end
