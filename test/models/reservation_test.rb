# == Schema Information
#
# Table name: reservations
#
#  id                    :integer          not null, primary key
#  count                 :integer
#  disapproval_message   :text
#  picked_up_count       :integer          default(0)
#  returned_unused_count :integer          default(0)
#  returned_used_count   :integer          default(0)
#  status                :integer          default("pending")
#  created_at            :datetime
#  updated_at            :datetime
#  item_id               :integer
#  partner_id            :bigint
#
# Indexes
#
#  index_reservations_on_item_id     (item_id)
#  index_reservations_on_partner_id  (partner_id)
#
# Foreign Keys
#
#  fk_rails_...  (partner_id => partners.id)
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
