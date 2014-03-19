require 'test_helper'

class PartnersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @partner = partners(:vtk)
    sign_in users(:tom)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:partners)
  end

  test "should show partner" do
    get :show, id: @partner
    assert_response :success
  end

  test "should create partner" do
    assert_difference 'Partner.count', +1 do
      xhr :post, :create, partner: { name: "Zeus", email: "zeus@zeus.zeus" }
    end

    assert_response :success
  end

  test "should get edit" do
    xhr :get, :edit, id: @partner

    assert_response :success
  end

  test "should update partner" do
    patch :update, id: @partner, partner: { name: "Zeus", email: "zeus@email.com" }

    assert_redirected_to partner_path(assigns(:partner))
  end

  test "should destroy partner" do
    assert_difference 'Partner.count', -1 do
      xhr :get, :destroy, id: @partner
    end

    assert_response :success
  end

  test "should get resend" do
    assert_difference "ActionMailer::Base.deliveries.size", +1 do
      xhr :get, :resend, id: @partner
    end

    assert_response :success
  end

end
