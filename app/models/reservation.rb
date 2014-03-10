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
#  approved     :boolean
#

class Reservation < ActiveRecord::Base
  belongs_to :item
  belongs_to :partner
end
