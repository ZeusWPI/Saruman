# == Schema Information
#
# Table name: reservations
#
#  id                  :integer          not null, primary key
#  item_id             :integer
#  user_id             :integer
#  count               :integer
#  fetched             :integer
#  brought_back        :integer
#  created_at          :datetime
#  updated_at          :datetime
#  status              :integer          default(1)
#  disapproval_message :text
#  picked_up_count     :integer          default(0)
#  brought_back_count  :integer          default(0)
#

class Reservation < ActiveRecord::Base
  extend Enumerize

  has_paper_trail only: [:count, :status, :picked_up_count, :brought_back_count]

  scope :approved, -> { where(status: 2) }
  scope :not_approved, -> { where.not(status: 2) }

  belongs_to :item
  belongs_to :user

  enumerize :status, in: { disapproved: 0, pending: 1, approved: 2 }

  validates :item_id, presence: true
  validates :count, numericality: { only_integer: true, greater_than: 0 }

  before_save :change_status

  def change_status
    self.status = :pending if count_changed? and not self.status.approved?
  end
end
