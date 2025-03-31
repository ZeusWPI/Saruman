require 'test_helper'

class ScanControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    sign_in users(:tom)
  end

  test "should get index" do
    get :scan
    assert_response :success
  end

  test "should fill in all fields" do
    post :check, params: { scan: { partner: '', item: '', count: '', options: 'out' } }
    assert_response :redirect
    assert_not_nil flash[:error]
    assert_equal flash[:error], "Please fill in all fields."

    post :check, params: { scan: { partner: partners(:vtk), item: '', count: '', options: 'out' } }
    assert_response :redirect
    assert_not_nil flash[:error]
    assert_equal flash[:error], "Please fill in all fields."

    post :check, params: { scan: { partner: '', item: items(:stoel), count: '', options: 'out' } }
    assert_response :redirect
    assert_not_nil flash[:error]
    assert_equal flash[:error], "Please fill in all fields."
  end

  test "both params should exist" do
    post :check, params: { scan: { partner: partners(:vtk), item: 'b - 1', count: '1', options: 'out' } }
    assert_response :redirect
    assert_not_nil flash[:error]
    assert_equal flash[:error], "The item or partner does not exist."

    post :check, params: { scan: { partner: 'a - 5', item: items(:stoel), count: '1', options: 'out' } }
    assert_response :redirect
    assert_not_nil flash[:error]
    assert_equal flash[:error], "The item or partner does not exist."

    post :check, params: { scan: { partner: partners(:vtk), item: items(:stoel), count: '1', options: 'out' } }
    assert_response :redirect
    assert_not_nil flash[:success]
    assert(flash[:success].include? "remaining to pick up")
  end

  test "partners should be found by barcode" do
    post :check, params: { scan: { partner: partners(:vtk), item: items(:stoel), count: '1', options: 'out' } }
    assert_response :redirect
    assert_not_nil flash[:success]
    assert(flash[:success].include? "#{partners(:vtk).name} picked up")
  end

  test "partners should be found by id" do
    post :check, params: { scan: { partner: partners(:vtk), item: items(:stoel), count: '1', options: 'out' } }
    assert_response :redirect
    assert_not_nil flash[:success]
    assert(flash[:success].include? "#{partners(:vtk).name} picked up")
  end

  test "checking in items from existing reservations should work" do
    post :check, params: { scan: { partner: partners(:vtk), item: items(:stoel), count: '1', options: 'return_unused' } }
    assert_response :redirect
    assert_not_nil flash[:notice]
    assert(flash[:notice].include? "#{partners(:vtk).name} brought back")
  end

  test "checking in items from non existing reservations should display a warning" do
    post :check, params: { scan: { partner: partners(:vlak), item: items(:stoel), count: '1', options: 'return_unused' } }
    assert_response :redirect
    assert_not_nil flash[:warning]
    assert(flash[:warning].include? "#{partners(:vlak).name} does not has a reservation for this item")
  end

  test "checking out items should work" do
    post :check, params: { scan: { partner: partners(:vtk), item: items(:stoel), count: '1', options: 'out' } }
    assert_response :redirect
    assert_not_nil flash[:success]
    assert(flash[:success].include? "#{partners(:vtk).name} picked up")
  end

  test "checking out items from non existing reservations should show a force add" do
    post :check, params: { scan: { partner: partners(:hilok), item: items(:stoel), count: '5', options: 'out' } }
    assert_response :success
    assert_select "strong", "no approved reservations for this item"
  end

  test "checking out too many items from existing reservations should show a force add" do
    post :check, params: { scan: { partner: partners(:vtk), item: items(:stoel), count: '5', options: 'out' } }
    assert_response :success
    assert_select "strong", "already picked up"
  end

  test "should be able to force add items to existing reservations" do
    post :force, params: { force: { partner_id: partners(:vtk), item_id: items(:stoel), count: 104 } }
    assert_response :redirect
    assert_not_nil flash[:notice]
    assert(flash[:notice].include? "Increased the existing reservation with")
    assert_not_nil Reservation.find_by_count(104)
  end

  test "should be able to force add items by creating new reservations" do
    post :force, params: { force: { partner_id: partners(:vtk), item_id: items(:tent), count: 100 } }
    assert_response :redirect
    assert_not_nil flash[:notice]
    assert(flash[:notice].include? "Created a new reservation for 100x Tent")
    assert_not_nil Reservation.find_by_count(100)
  end

end
