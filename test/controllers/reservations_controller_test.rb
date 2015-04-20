require 'test_helper'

class ReservationsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @reservation = reservations(:vtk_tent)
    sign_in users(:vtk)
  end

  test "should get index" do
    get :index, user_id: users(:vtk)

    assert_response :redirect
  end

  test "should show reservation" do
    xhr :get, :show, user_id: users(:vtk), id: @reservation

    assert_response :success
  end

  test "should create reservation" do
    assert_difference 'Reservation.count', +1 do
      xhr :post, :create, user_id: users(:vtk), reservation: { item_id: items(:vat), count: 5 }
    end

    assert_response :success
  end

  test "shouldnt create reservation after deadline" do
    Settings.instance.update_attributes! deadline: DateTime.now - 1

    assert_difference 'Reservation.count', +0 do
      xhr :post, :create, user_id: users(:vtk), reservation: { item_id: items(:vat), count: 5 }
    end

    assert_response :redirect

    ability = Ability.new(users :vtk)
    assert ability.cannot? :create, Reservation
  end

  test "admins can edit reservations after deadline" do
    sign_out users(:vtk)
    sign_in users(:tom)

    Settings.instance.update_attributes! deadline: DateTime.now - 1

    assert_difference 'Reservation.count', +1 do
      xhr :post, :create, user_id: users(:vtk), reservation: { item_id: items(:vat), count: 5 }
    end

    assert_response :success

    ability = Ability.new(users :tom)
    assert ability.can? :create, Reservation
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

  test "shouldnt update reservation after deadline" do
    Settings.instance.update_attributes! deadline: DateTime.now - 1

    ability = Ability.new(users :vtk)
    assert ability.cannot? :update, @reservation

    xhr :patch, :update, user_id: users(:vtk), id: @reservation, reservation: { count: 10 }

    assert_response :redirect
    @reservation.reload
    assert_equal @reservation.count, 1
  end

  test "should destroy reservation" do
    assert_difference 'Reservation.count', -1 do
      xhr :get, :destroy, user_id: users(:vtk), id: @reservation
    end

    assert_response :success
  end

  test "shouldnt destroy reservation after deadline" do
    Settings.instance.update_attributes! deadline: DateTime.now - 1

    ability = Ability.new(users :vtk)
    assert ability.cannot? :destroy, @reservation

    assert_difference 'Reservation.count', 0 do
      xhr :get, :destroy, user_id: users(:vtk), id: @reservation
    end

    assert_response :redirect
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
    assert_not Reservation.exists? reservations(:vtk_stoel_unapproved).id
    assert_equal reservations(:vtk_stoel_approved).count, 8
  end

  test "don't add newly approved items to unapproved matches" do
    sign_out users(:vtk)
    sign_in users(:tom)

    @pending = reservations(:vtk_tent)
    @unapproved = reservations(:vtk_tent_unapproved)
    xhr :get, :approve, user_id: users(:vtk), id: @unapproved
    assert_response :success

    # Tent remained the same
    assert Reservation.exists? @pending.id
    assert_equal @pending.count, 1
    assert_equal @pending.status, 'pending'

    # Unapproved tent got approved, rest stays the same
    @unapproved.reload
    assert Reservation.exists? @unapproved.id
    assert_equal @unapproved.count, 1
    assert_equal @unapproved.status, 'approved'
  end

  test "don't add newly approved items to approved matches from other partners" do
    sign_out users(:vtk)
    sign_in users(:tom)

    @approved_vtk = reservations(:vtk_stoel_approved)
    @pending_vlak = reservations(:vlak_stoel_pending)
    xhr :get, :approve, user_id: users(:vlak), id: @pending_vlak
    assert_response :success

    # Tent remained the same
    @approved_vtk.reload
    assert Reservation.exists? @approved_vtk.id
    assert_equal @approved_vtk.count, 4
    assert_equal @approved_vtk.status, 'approved'

    # Unapproved tent got approved, rest stays the same
    @pending_vlak.reload
    assert Reservation.exists? @pending_vlak.id
    assert_equal @pending_vlak.count, 1
    assert_equal @pending_vlak.status, 'approved'
  end

  test "should be able to revert normal pick up" do
    sign_out users(:vtk)
    sign_in users(:tom)

    @approved_vtk = reservations(:vtk_stoel_approved)
    @approved_vtk.picked_up_count = 4
    @approved_vtk.save

    @approved_vtk.reload
    assert @approved_vtk.picked_up_count == 4
    assert @approved_vtk.count == 4

    get :revert, user_id: users(:vtk), id: @approved_vtk
    assert_response :redirect

    @approved_vtk.reload
    assert @approved_vtk.picked_up_count == 0
  end

  test "should be able to revert forced increasing pick up" do
    sign_out users(:vtk)
    sign_in users(:tom)

    @approved_vtk = reservations(:vtk_stoel_approved)
    @approved_vtk.count = 6
    @approved_vtk.picked_up_count = 6
    @approved_vtk.save

    @approved_vtk.reload
    assert @approved_vtk.picked_up_count == 6
    assert @approved_vtk.count == 6

    get :revert, user_id: users(:vtk), id: @approved_vtk
    assert_response :redirect

    @approved_vtk.reload
    assert @approved_vtk.picked_up_count == 0
    assert @approved_vtk.count == 4
  end

  test "should be able to revert forced new pick up" do
    sign_out users(:vtk)
    sign_in users(:tom)

    @approved_vtk = reservations(:vtk_stoel_approved)

    assert_difference 'Reservation.count', -1, 'A Reservation should be destroyed' do
      get :revert, user_id: users(:vtk), id: @approved_vtk
    end

    assert_response :redirect
  end

  test "should be able to revert bringback" do
    sign_out users(:vtk)
    sign_in users(:tom)

    @approved_vtk = reservations(:vtk_vat_approved_picked_up)
    @approved_vtk.brought_back_count = 2
    @approved_vtk.save

    @approved_vtk.reload
    assert @approved_vtk.brought_back_count == 2

    get :revert, user_id: users(:vtk), id: @approved_vtk
    assert_response :redirect

    @approved_vtk.reload
    assert @approved_vtk.brought_back_count == 0
  end

end
