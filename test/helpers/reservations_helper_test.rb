require 'test_helper'

class ReservationsHelperTest < ActionView::TestCase

  test "should get correct handler" do
    r = reservations(:vtk_tent)

    r.status = :approved
    assert_match(/Approved/, status(r))

    r.status = :pending
    assert_match(/Pending/, status(r))

    r.status = :disapproved
    assert_match(/Disapproved/, status(r))
  end

end
