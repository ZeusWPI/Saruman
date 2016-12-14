# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#

class User < ActiveRecord::Base
  default_scope { order "name ASC" }

  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable

  has_many :reservations, dependent: :destroy

  validates :name, uniqueness: true, presence: true

  before_save do
    self.sent = false if email_changed?
    true
  end

  def send_token
    self.sent = true
    self.save
    PartnerMailer.send_token(self).deliver_now
  end

  def send_barcode
    PartnerMailer.send_barcode(self).deliver_now
  end

end
