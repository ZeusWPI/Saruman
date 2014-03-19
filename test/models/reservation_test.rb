require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  verify_fixtures Reservation

  test "status changes to pending after change" do
    reservation = reservations(:vtk_tent)
    reservation.status = :disapproved

    reservation.count = 5
    reservation.save

    assert_equal reservation.status, "pending"
  end
end
