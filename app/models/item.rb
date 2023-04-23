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
#

class Item < ApplicationRecord
  include Barcodable

  default_scope { order "name ASC" }

  has_many :reservations

  validates :name,     presence: true, uniqueness: true
  validates :price,    presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :category, presence: true

  enum category: %w[drank materiaal]

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
