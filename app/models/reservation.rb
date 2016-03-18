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
  has_paper_trail only: [:count, :status, :picked_up_count, :brought_back_count]

  belongs_to :item
  belongs_to :user

  enum status: %w(disapproved pending approved)

  validates :item, presence: true
  validates :count, numericality: { only_integer: true, greater_than: 0 }

  before_save :change_status

  def change_status
    self.status = :pending if count_changed? and not self.approved?
  end

  def self.category c
    joins(:item).where("items.category = ?", c)
  end

  def self.sum_picked_up
    sum("reservations.picked_up_count*items.price/100.0")
  end

  def approve
    duplicate = self.user.reservations.approved.find_by_item_id self.item_id
    if duplicate.nil?
      self.disapproval_message = nil
      self.status = :approved
      self.save
    else
      duplicate.count += self.count
      duplicate.save
      self.destroy
    end
  end
end
