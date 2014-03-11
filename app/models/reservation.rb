# == Schema Information
#
# Table name: reservations
#
#  id           :integer          not null, primary key
#  item_id      :integer
#  partner_id   :integer
#  count        :integer
#  fetched      :integer
#  brought_back :integer
#  created_at   :datetime
#  updated_at   :datetime
#  status       :integer          default(1)
#

class Reservation < ActiveRecord::Base
  extend Enumerize

  belongs_to :item
  belongs_to :partner

  enumerize :status, in: { disapproved: 0, pending: 1, approved: 2 }

  has_paper_trail

  validates :item_id, uniqueness: { scope: :partner_id },  presence: true
  validates :count, numericality: { only_integer: true, greater_than: 0 }
end
