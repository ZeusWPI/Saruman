require 'test_helper'

class ReservationsHelperTest < ActionView::TestCase

  test "should get correct handler" do
    r = reservations(:vtk_tent)

    r.status = :approved
    assert_match(/Approved/, status(r.status))

    r.status = :pending
    assert_match(/Pending/, status(r.status))

    r.status = :disapproved
    assert_match(/Disapproved/, status(r.status))
  end

end
