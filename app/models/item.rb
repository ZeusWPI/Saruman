class Item < ApplicationRecord
  include Barcodable

  default_scope { order "name ASC" }

  has_many :reservations

  validates :name,     presence: true, uniqueness: true
  validates :price,    presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :deposit,  presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :category, presence: true

  enum category: %w[drank materiaal]

  def to_s
    [
      name,
      description.present? ? description : nil,
      "€#{'%0.2f' % price}",
      "(€#{'%0.2f' % deposit})"
    ].compact.join(" - ")
  end

  def price
    from_cents read_attribute(:price)
  end

  def price=(value)
    write_attribute(:price, to_cents(value))
  end

  def deposit
    from_cents read_attribute(:deposit)
  end

  def deposit=(value)
    write_attribute(:deposit, to_cents(value))
  end

  def total_price
    price + deposit
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

# == Schema Information
#
# Table name: items
#
#  id           :integer          not null, primary key
#  barcode      :string
#  barcode_data :string
#  category     :integer
#  deposit      :integer          default(0)
#  description  :string
#  name         :string
#  price        :integer
#  quantity     :integer
#  created_at   :datetime
#  updated_at   :datetime
#
