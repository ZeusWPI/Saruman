# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  price       :integer
#  created_at  :datetime
#  updated_at  :datetime
#  quantity    :integer
#

class Item < ActiveRecord::Base

  validates :name, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def price
    from_cents read_attribute(:price)
  end

  def price=(value)
    write_attribute(:price, to_cents(value))
  end

  private

  def from_cents(value)
    (value || 0) / 100.0
  end

  def to_cents(value)
    if value.is_a? String then value.sub!(',', '.') end
    (value.to_f * 100).to_int
  end
end
