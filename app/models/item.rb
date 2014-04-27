# == Schema Information
#
# Table name: items
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  description  :string(255)
#  price        :integer
#  created_at   :datetime
#  updated_at   :datetime
#  quantity     :integer
#  barcode      :string(255)
#  barcode_data :string(255)
#

class Item < ActiveRecord::Base
  include Barcodable

  default_scope { order "name ASC" }

  has_many :reservations

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def price
    from_cents read_attribute(:price)
  end

  def price=(value)
    write_attribute(:price, to_cents(value))
  end

  def name_with_price
    if price > 0
      "#{name} - €#{'%0.2f' % price}"
    else
      name
    end
  end

  def name_with_descr_price
    if price > 0 and not description.blank?
      "#{name} - #{description} - €#{'%0.2f' % price}"
    elsif description.blank?
      name_with_price
    else
      "#{name} - #{description}"
    end
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
