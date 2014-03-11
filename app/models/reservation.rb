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
#  approved     :boolean          default(FALSE)
#

class Reservation < ActiveRecord::Base
  belongs_to :item
  belongs_to :partner

  has_paper_trail

  validates :item_id, uniqueness: { scope: :partner_id },  presence: true
  validates :count, numericality: { only_integer: true, greater_than: 0 }

end
