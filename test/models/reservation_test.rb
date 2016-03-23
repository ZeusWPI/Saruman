# == Schema Information
#
# Table name: reservations
#
#  id                  :integer          not null, primary key
#  item_id             :integer
#  user_id             :integer
#  count               :integer
#  brought_back        :integer
#  created_at          :datetime
#  updated_at          :datetime
#  status              :integer          default(1)
#  disapproval_message :text
#  picked_up_count     :integer          default(0)
#  brought_back_count  :integer          default(0)
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
