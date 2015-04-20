require 'test_helper'

class ScanControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    sign_in users(:tom)
  end

  test "should get index" do
    get :scan
    assert_response :success
  end

  test "should fill in all fields" do
    post :check, scan: { partner_code: '', item_id: '', count: '', options: 'out' }
    assert_response :redirect
    assert_not_nil flash[:error]
    assert_equal flash[:error], "Please fill in all fields."

    post :check, scan: { partner_code: 'b', item_id: '', count: '', options: 'out' }
    assert_response :redirect
    assert_not_nil flash[:error]
    assert_equal flash[:error], "Please fill in all fields."

    post :check, scan: { partner_code: '', item_id: 'c', count: '', options: 'out' }
    assert_response :redirect
    assert_not_nil flash[:error]
    assert_equal flash[:error], "Please fill in all fields."
  end

  test "both params should exist" do
    post :check, scan: { partner_code: '1337', item_id: 'b', count: '1', options: 'out' }
    assert_response :redirect
    assert_not_nil flash[:error]
    assert_equal flash[:error], "The item or partner does not exist."

    post :check, scan: { partner_code: 'a', item_id: items(:stoel), count: '1', options: 'out' }
    assert_response :redirect
    assert_not_nil flash[:error]
    assert_equal flash[:error], "The item or partner does not exist."

    post :check, scan: { partner_code: '1337', item_id: items(:stoel), count: '1', options: 'out' }
    assert_response :redirect
    assert_not_nil flash[:success]
    assert(flash[:success].include? "remaining to pick up")
  end

  test "partners should be found by barcode" do
    post :check, scan: { partner_code: users(:vtk).barcode, item_id: items(:stoel), count: '1', options: 'out' }
    assert_response :redirect
    assert_not_nil flash[:success]
    assert(flash[:success].include? "#{users(:vtk).name} picked up")
  end

  test "partners should be found by id" do
    post :check, scan: { partner_code: '', partner_id: users(:vtk), item_id: items(:stoel), count: '1', options: 'out' }
    assert_response :redirect
    assert_not_nil flash[:success]
    assert(flash[:success].include? "#{users(:vtk).name} picked up")
  end

  test "checking in items from existing reservations should work" do
    post :check, scan: { partner_code: '', partner_id: users(:vtk), item_id: items(:stoel), count: '1', options: 'in' }
    assert_response :redirect
    assert_not_nil flash[:notice]
    assert(flash[:notice].include? "#{users(:vtk).name} brought back")
  end

  test "checking in items from non existing reservations should display a warning" do
    post :check, scan: { partner_code: '', partner_id: users(:vlak), item_id: items(:stoel), count: '1', options: 'in' }
    assert_response :redirect
    assert_not_nil flash[:warning]
    assert(flash[:warning].include? "#{users(:vlak).name} does not has a reservation for this item")
  end

  test "checking out items should work" do
    post :check, scan: { partner_code: '', partner_id: users(:vtk), item_id: items(:stoel), count: '1', options: 'out' }
    assert_response :redirect
    assert_not_nil flash[:success]
    assert(flash[:success].include? "#{users(:vtk).name} picked up")
  end

  test "checking out items from non existing reservations should show a force add" do
    post :check, scan: { partner_code: '', partner_id: users(:hilok), item_id: items(:stoel), count: '5', options: 'out' }
    assert_response :success
    assert_select "strong", "no approved reservations for this item"
  end

  test "checking out too many items from existing reservations should show a force add" do
    post :check, scan: { partner_code: '', partner_id: users(:vtk), item_id: items(:stoel), count: '5', options: 'out' }
    assert_response :success
    assert_select "strong", "already picked up"
  end

  test "should be able to force add items to existing reservations" do
    post :force, force: { partner_id: users(:vtk), item_id: items(:stoel), count: 104 }
    assert_response :redirect
    assert_not_nil flash[:notice]
    assert(flash[:notice].include? "Increased the existing reservation with")
    assert_not_nil Reservation.find_by_count(104)
  end

  test "should be able to force add items by creating new reservations" do
    post :force, force: { partner_id: users(:vtk), item_id: items(:tent), count: 100 }
    assert_response :redirect
    assert_not_nil flash[:notice]
    assert(flash[:notice].include? "Created a new reservation for 100x Tent")
    assert_not_nil Reservation.find_by_count(100)
  end

end
