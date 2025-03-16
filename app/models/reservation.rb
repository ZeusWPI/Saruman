class Reservation < ApplicationRecord
  has_paper_trail only: [:count, :status, :picked_up_count, :returned_unused_count, :returned_used_count]

  belongs_to :item
  belongs_to :user

  enum :status, %w(disapproved pending approved)

  validates :item, presence: true
  validates :count, numericality: { only_integer: true, greater_than: 0 }

  before_save :change_status

  scope :ordered_by_item_name, -> { joins(:item).order('items.name': :asc) }

  class << self
    def category(c)
      joins(:item).where("items.category = ?", c)
    end

    def usage_cost
      joins(:item).pluck(:picked_up_count, :returned_unused_count, :'items.price')
        .sum do |picked_up_count, returned_unused_count, price|
        ((picked_up_count - returned_unused_count) * price)
      end / 100.0
    end

    def deposit_cost
      joins(:item).pluck(:picked_up_count, :returned_used_count, :returned_unused_count, :'items.deposit')
        .sum do |picked_up_count, returned_used_count, returned_unused_count, deposit|
          ((picked_up_count - returned_unused_count - returned_used_count) * deposit)
      end / 100.0
    end

    def total_cost
      # Take 5 picked up kegs at 10 euro, deposit of 5 euro.
      # 3 are returned empty (used), 1 is returned full (unused), 1 got lost
      # - 75: picking up 5 kegs (5 x 10 price) + (5 x 5 deposit)
      # + 15: returning 3 empty kegs (3 x 5 deposit)
      # + 15: returning 1 unused keg (1 x 10 price + 1 x 5 deposit)
      # Costs involved:
      # - 40 euro for 4 used kegs
      # - 5 euro deposit for keg that got lost
      joins(:item).pluck(:picked_up_count, :returned_used_count, :returned_unused_count, :'items.price', :'items.deposit')
        .sum do |picked_up_count, returned_used_count, returned_unused_count, price, deposit|
        ((picked_up_count - returned_unused_count) * price) + # (5 - 1) * 10 = 40
          ((picked_up_count - returned_unused_count - returned_used_count) * deposit) # (5 - 1 - 3) * 5 = 5
      end / 100.0
    end
  end

  def change_status
    self.status = :pending if count_changed? and not self.approved?
  end

  def returned_count
    returned_used_count + returned_unused_count
  end

  def used_count
    picked_up_count - returned_unused_count
  end

  def missing_count
    picked_up_count - returned_used_count - returned_unused_count
  end

  def missing?
    missing_count > 0
  end

  def reservation_cost
    count * item.price
  end

  def usage_cost
    used_count * item.price
  end

  def deposit_cost
    missing_count * item.deposit
  end

  def total_cost
    usage_cost + deposit_cost
  end

  def approve
    duplicate = self.user.reservations.approved.find_by(item_id: self.item_id)
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
#  user_id               :integer
#
# Indexes
#
#  index_reservations_on_item_id  (item_id)
#  index_reservations_on_user_id  (user_id)
#
