# == Schema Information
#
# Table name: items
#
#  id                       :bigint           not null, primary key
#  name                     :string(255)
#  description              :string(255)
#  price                    :integer
#  created_at               :datetime
#  updated_at               :datetime
#  quantity                 :integer
#  barcode                  :string(255)
#  barcode_data             :string(255)
#  barcode_img_file_name    :string(255)
#  barcode_img_content_type :string(255)
#  barcode_img_file_size    :bigint
#  barcode_img_updated_at   :datetime
#  category                 :integer
#  deposit                  :integer
#

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
