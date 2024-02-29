class User < ApplicationRecord
  include Barcodable

  ROLES = %w[admin partner]

  acts_as_token_authenticatable

  scope :ordered_by_name, -> { order(name: :asc) }
  scope :admins, -> { where(role: 'admin') }
  scope :partners, -> { where(role: 'partner') }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable,
         :registerable

  has_many :reservations, dependent: :destroy

  validates :name, uniqueness: true, presence: true

  before_save do
    self.sent = false if email_changed?
    true
  end

  def send_token
    PartnerMailer.send_token(self).deliver_now
    self.update!(sent: true)
  end

  def send_barcode
    PartnerMailer.send_barcode(self).deliver_now
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  authentication_token   :string
#  barcode                :string
#  barcode_data           :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string           default("partner")
#  sent                   :boolean          default(TRUE)
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime
#  updated_at             :datetime
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
