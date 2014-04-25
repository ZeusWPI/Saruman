# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  authentication_token   :string(255)
#  role                   :string(255)      default("partner")
#  name                   :string(255)
#  sent                   :boolean          default(TRUE)
#  barcode                :string(255)
#  barcode_data           :string(255)
#

class User < ActiveRecord::Base
  include Barcodable

  ROLES = %w[admin partner]

  acts_as_token_authenticatable

  default_scope { order "name ASC" }
  scope :admins, -> { where(role: 'admin') }
  scope :partners, -> { where(role: 'partner') }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable,
         :registerable

  has_many :reservations

  validates :name, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true, email: true

  before_save do
    self.sent = false if email_changed?
    true
  end

  def send_token
    self.sent = true
    self.save
    PartnerMailer.send_token(self).deliver
  end

end
