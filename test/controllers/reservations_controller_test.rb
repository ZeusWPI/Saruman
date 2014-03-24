require 'test_helper'

class ReservationsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @reservation = reservations(:vtk_tent)
    sign_in users(:vtk)
  end

  test "should get index" do
    get :index, user_id: users(:vtk)

    assert_response :success
    assert_not_nil assigns(:reservations)
  end

  test "should show reservation" do
    xhr :get, :show, user_id: users(:vtk), id: @reservation

    assert_response :success
  end

  test "should create reservation" do
    assert_difference 'Reservation.count', +1 do
      xhr :post, :create, user_id: users(:vtk), reservation: { item_id: 2, count: 5 }
    end

    assert_response :success
  end

  test "should get edit" do
    xhr :get, :edit, user_id: users(:vtk), id: @reservation

    assert_response :success
  end

  test "should update reservation" do
    xhr :patch, :update, user_id: users(:vtk), id: @reservation, reservation: { count: 10 }

    assert_response :success
    @reservation.reload
    assert_equal @reservation.count, 10
  end

  test "should destroy reservation" do
    assert_difference 'Reservation.count', -1 do
      xhr :get, :destroy, user_id: users(:vtk), id: @reservation
    end

    assert_response :success
  end

  test "should change status" do
    sign_out users(:vtk)
    sign_in users(:tom)

    assert @reservation.status.pending?

    xhr :get, :approve, user_id: users(:vtk), id: @reservation
    @reservation.reload
    assert_response :success
    assert @reservation.status.approved?

    xhr :post, :disapprove, user_id: users(:vtk), disapprove: { id: @reservation.id, reason: "Too many items" }
    @reservation.reload
    assert_response :success
    assert @reservation.status.disapproved?
    assert_equal @reservation.disapproval_message, "Too many items"
  end

  test "partners can't change status" do
    xhr :get, :approve, user_id: users(:vtk), id: @reservation
    assert_response :redirect
  end

  test "only admins can change status" do
    sign_out users(:vtk)
    sign_in users(:tom)

    xhr :get, :approve, user_id: users(:vtk), id: @reservation
    assert_response :success
  end

  test "add newly approved items to already approved matches" do
    sign_out users(:vtk)
    sign_in users(:tom)

    xhr :get, :approve, user_id: users(:vtk), id: reservations(:vtk_stoel_unapproved)
    assert_response :success
    assert_equal reservations(:vtk_stoel_approved).count, 8
    assert_not Reservation.exists? reservations(:vtk_stoel_unapproved)
  end

  test "don't add newly approved items to unapproved matches" do
    sign_out users(:vtk)
    sign_in users(:tom)

    @pending = reservations(:vtk_tent)
    @unapproved = reservations(:vtk_tent_unapproved)
    xhr :get, :approve, user_id: users(:vtk), id: @unapproved
    assert_response :success

    # Tent remained the same
    assert_equal @pending.count, 1
    assert_equal @pending.status, 'pending'
    assert Reservation.exists? @pending

    # Unapproved tent got approved, rest stays the same
    @unapproved.reload
    assert_equal @unapproved.count, 1
    assert_equal @unapproved.status, 'approved'
    assert Reservation.exists? @unapproved
  end

  test "don't add newly approved items to approved matches from other partners" do
    sign_out users(:vtk)
    sign_in users(:tom)

    @approved_vtk = reservations(:vtk_tent_approved)
    @pending_hilok = reservations(:hilok_tent)
    xhr :get, :approve, user_id: users(:hilok), id: @pending_hilok
    assert_response :success

    # Tent remained the same
    assert_equal @approved_vtk.count, 1
    assert_equal @approved_vtk.status, 'approved'
    assert Reservation.exists? @approved_vtk

    # Unapproved tent got approved, rest stays the same
    @pending_hilok.reload
    assert_equal @pending_hilok.count, 5
    assert_equal @pending_hilok.status, 'approved'
    assert Reservation.exists? @pending_hilok
  end
end
