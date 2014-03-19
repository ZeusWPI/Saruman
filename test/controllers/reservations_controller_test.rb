require 'test_helper'

class ReservationsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @reservation = reservations(:vtk_tent)
    sign_in partners(:vtk)
  end

  test "should get index" do
    get :index, partner_id: partners(:vtk)

    assert_response :success
    assert_not_nil assigns(:reservations)
  end

  test "should show reservation" do
    get :show, partner_id: partners(:vtk), id: @reservation

    assert_response :success
  end

  test "should create reservation" do
    assert_difference 'Reservation.count', +1 do
      xhr :post, :create, partner_id: partners(:vtk), reservation: { item_id: 2, count: 5 }
    end

    assert_response :success
  end

  test "should get edit" do
    xhr :get, :edit, partner_id: partners(:vtk), id: @reservation

    assert_response :success
  end

  test "should update reservation" do
    xhr :patch, :update, partner_id: partners(:vtk), id: @reservation, reservation: { count: 10 }

    assert_response :success
  end

  test "should destroy reservation" do
    assert_difference 'Reservation.count', -1 do
      xhr :get, :destroy, partner_id: partners(:vtk), id: @reservation
    end

    assert_response :success
  end
end
