require 'test_helper'

class ReservationsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @reservation = reservations(:vtk_tent)
    sign_in users(:vtk_user)
  end

  test "should get index" do
    get :index, params: { partner_id: partners(:vtk) }

    assert_response :success
    assert_not_nil assigns(:partner)
  end

  test "should not show other user for partners" do
    get :index, params: { partner_id: partners(:hilok) }
    assert_response :redirect
  end

  test "should show warning for partners after deadline" do
    Settings.instance.update! deadline: DateTime.now - 1

    get :index, params: { partner_id: partners(:vtk) }
    assert_response :success
    assert_not_nil assigns(:partner)
    assert_match(/The deadline for reservations/, response.body)
    assert_select "table-responsive form", false
  end

  test "dont show warning for admins after deadline" do
    Settings.instance.update! deadline: DateTime.now - 1

    sign_out users(:vtk_user)
    sign_in users(:tom)

    get :index, params: { partner_id: partners(:vtk) }
    assert_response :success
    assert_not_nil assigns(:partner)
    assert_no_match(/The deadline for reservations/, response.body)
    assert_select "form"
  end

  test "should create reservation" do
    assert_difference 'Reservation.count', +1 do
      post :create, xhr: true, params: { partner_id: partners(:vtk), reservation: { item_id: items(:vat), count: 5 } }
    end

    assert_response :success
  end

  test "shouldnt create reservation after deadline" do
    Settings.instance.update! deadline: DateTime.now - 1

    assert_difference 'Reservation.count', +0 do
      post :create, xhr: true, params: { partner_id: partners(:vtk), reservation: { item_id: items(:vat), count: 5 } }
    end

    assert_response :found

    ability = Ability.new(users(:vtk_user))
    assert ability.cannot? :create, Reservation
  end

  test "admins can edit reservations after deadline" do
    sign_out users(:vtk_user)
    sign_in users(:tom)

    Settings.instance.update! deadline: DateTime.now - 1

    assert_difference 'Reservation.count', +1 do
      post :create, xhr: true, params: { partner_id: partners(:vtk), reservation: { item_id: items(:vat), count: 5 } }
    end

    assert_response :success

    ability = Ability.new(users(:tom))
    assert ability.can? :create, Reservation
  end

  test "should get edit" do
    get :edit, xhr: true, params: { partner_id: partners(:vtk), id: @reservation }

    assert_response :success
  end

  test "should update reservation" do
    patch :update, xhr: true, params: { partner_id: partners(:vtk), id: @reservation, reservation: { count: 10 } }

    assert_response :success
    @reservation.reload
    assert_equal @reservation.count, 10
  end

  test "shouldnt update reservation after deadline" do
    Settings.instance.update! deadline: DateTime.now - 1

    ability = Ability.new(users(:vtk_user))
    assert ability.cannot? :update, @reservation

    patch :update, xhr: true, params: { partner_id: partners(:vtk), id: @reservation, reservation: { count: 10 } }

    assert_response :found
    @reservation.reload
    assert_equal @reservation.count, 1
  end

  test "should destroy reservation" do
    assert_difference 'Reservation.count', -1 do
      get :destroy, xhr: true, params: { partner_id: partners(:vtk), id: @reservation }
    end

    assert_response :success
  end

  test "shouldnt destroy reservation after deadline" do
    Settings.instance.update!(deadline: DateTime.now - 1)

    ability = Ability.new(users(:vtk_user))
    assert ability.cannot? :destroy, @reservation

    assert_difference 'Reservation.count', 0 do
      get :destroy, xhr: true, params: { partner_id: partners(:vtk), id: @reservation }
    end

    assert_response :redirect
  end

  test "should change status" do
    sign_out users(:vtk_user)
    sign_in users(:tom)

    assert @reservation.pending?

    get :approve, xhr: true, params: { partner_id: partners(:vtk), id: @reservation }
    @reservation.reload
    assert_response :success
    assert @reservation.approved?

    post :disapproved, xhr: true, params: { partner_id: partners(:vtk), id: @reservation.id, disapprove: { reason: "Too many items" } }
    @reservation.reload
    assert_response :success
    assert @reservation.disapproved?
    assert_equal @reservation.disapproval_message, "Too many items"
  end

  test "partners can't approve_all" do
    post :approve_all, xhr: true, params: { partner_id: partners(:vtk) }
    assert_response :found
    assert_not_equal Reservation.where(partner_id: partners(:vtk)).pending.size, 0
  end

  test "only admins can approve_all" do
    sign_out users(:vtk_user)
    sign_in users(:tom)

    post :approve_all, xhr: true, params: { partner_id: partners(:vtk) }
    assert_response :found
  end

  test "approve_all reservations should approve them" do
    sign_out users(:vtk_user)
    sign_in users(:tom)

    post :approve_all, xhr: true, params: { partner_id: partners(:vtk) }
    assert_equal Reservation.where(partner_id: partners(:vtk)).pending.size, 0
  end

  test "partners can't change status" do
    get :approve, xhr: true, params: { partner_id: partners(:vtk), id: @reservation }
    assert_response :redirect
  end

  test "only admins can change status" do
    sign_out users(:vtk_user)
    sign_in users(:tom)

    get :approve, xhr: true, params: { partner_id: partners(:vtk), id: @reservation }
    assert_response :success
  end

  test "add newly approved items to already approved matches" do
    sign_out users(:vtk_user)
    sign_in users(:tom)

    get :approve, xhr: true, params: { partner_id: partners(:vtk), id: reservations(:vtk_stoel_unapproved) }
    assert_response :success
    assert_not Reservation.exists? reservations(:vtk_stoel_unapproved).id
    assert_equal reservations(:vtk_stoel_approved).count, 8
  end

  test "don't add newly approved items to unapproved matches" do
    sign_out users(:vtk_user)
    sign_in users(:tom)

    @pending = reservations(:vtk_tent)
    @unapproved = reservations(:vtk_tent_unapproved)
    get :approve, xhr: true, params: { partner_id: partners(:vtk), id: @unapproved }
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
    sign_out users(:vtk_user)
    sign_in users(:tom)

    @approved_vtk = reservations(:vtk_stoel_approved)
    @pending_vlak = reservations(:vlak_stoel_pending)
    get :approve, xhr: true, params: { partner_id: partners(:vlak), id: @pending_vlak }
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
    sign_out users(:vtk_user)
    sign_in users(:tom)

    @approved_vtk = reservations(:vtk_stoel_approved)
    @approved_vtk.picked_up_count = 4
    @approved_vtk.save

    @approved_vtk.reload
    assert @approved_vtk.picked_up_count == 4
    assert @approved_vtk.count == 4

    get :revert, params: { partner_id: partners(:vtk), id: @approved_vtk }
    assert_response :redirect

    @approved_vtk.reload
    assert @approved_vtk.picked_up_count == 0
  end

  test "should be able to revert forced increasing pick up" do
    sign_out users(:vtk_user)
    sign_in users(:tom)

    @approved_vtk = reservations(:vtk_stoel_approved)
    @approved_vtk.count = 6
    @approved_vtk.picked_up_count = 6
    @approved_vtk.save

    @approved_vtk.reload
    assert @approved_vtk.picked_up_count == 6
    assert @approved_vtk.count == 6

    get :revert, params: { partner_id: partners(:vtk), id: @approved_vtk }
    assert_response :redirect

    @approved_vtk.reload
    assert @approved_vtk.picked_up_count == 0
    assert @approved_vtk.count == 4
  end

  test "should be able to revert forced new pick up" do
    sign_out users(:vtk_user)
    sign_in users(:tom)

    @approved_vtk = reservations(:vtk_stoel_approved)

    assert_difference 'Reservation.count', -1, 'A Reservation should be destroyed' do
      get :revert, params: { partner_id: partners(:vtk), id: @approved_vtk }
    end

    assert_response :redirect
  end

  test "should be able to revert unused return" do
    sign_out users(:vtk_user)
    sign_in users(:tom)

    @approved_vtk = reservations(:vtk_vat_approved_picked_up)
    @approved_vtk.returned_unused_count = 2
    @approved_vtk.save!

    @approved_vtk.reload
    assert @approved_vtk.returned_unused_count == 2

    get :revert, params: { partner_id: partners(:vtk), id: @approved_vtk }
    assert_response :redirect

    @approved_vtk.reload
    assert @approved_vtk.returned_unused_count == 0
  end

  test "should be able to revert used return" do
    sign_out users(:vtk_user)
    sign_in users(:tom)

    @approved_vtk = reservations(:vtk_vat_approved_picked_up)
    @approved_vtk.returned_used_count = 2
    @approved_vtk.save!

    @approved_vtk.reload
    assert @approved_vtk.returned_used_count == 2

    get :revert, params: { partner_id: partners(:vtk), id: @approved_vtk }
    assert_response :redirect

    @approved_vtk.reload
    assert @approved_vtk.returned_used_count == 0
  end
end
