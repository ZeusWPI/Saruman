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

  test "should create partner" do
    assert_difference('Partner.count') do
      post :create, partner: { name: "Zeus", email: "zeus@zeus.zeus" }
    end

    assert_redirected_to partner_path(assigns(:partner))
  end

  test "should show partner" do
    get :show, id: @partner
    assert_response :success
  end

  test "should update item" do
    patch :update, id: @partner, partner: { name: "Zeus", email: "zeus@email.com" }
    assert_redirected_to partner_path(assigns(:partner))
  end
end
