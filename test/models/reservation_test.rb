# == Schema Information
#
# Table name: reservations
#
#  id                    :bigint           not null, primary key
#  item_id               :integer
#  user_id               :integer
#  count                 :integer
#  created_at            :datetime
#  updated_at            :datetime
#  status                :integer          default("pending")
#  disapproval_message   :text(65535)
#  picked_up_count       :integer          default(0)
#  returned_unused_count :integer          default(0)
#  returned_used_count   :integer          default(0)
#

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
