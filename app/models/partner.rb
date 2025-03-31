class Partner < ApplicationRecord
  include Barcodable

  has_many :reservations, dependent: :destroy
  has_many :users, dependent: :destroy

  scope :ordered_by_name, -> { order(name: :asc) }

  validates :name, uniqueness: true, presence: true

  accepts_nested_attributes_for :users

  def send_barcode
    PartnerMailer.send_barcode(self).deliver_now
  end

  def all_tokens_sent?
    !users.exists?(sent: false)
  end
end

# == Schema Information
#
# Table name: partners
#
#  id           :bigint           not null, primary key
#  barcode      :string           not null
#  barcode_data :string           not null
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_partners_on_name  (name) UNIQUE
#
