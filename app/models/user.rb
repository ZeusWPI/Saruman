# == Schema Information
#
# Table name: users
#
#  id                       :bigint           not null, primary key
#  email                    :string(255)      default(""), not null
#  encrypted_password       :string(255)      default(""), not null
#  reset_password_token     :string(255)
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :string(255)
#  last_sign_in_ip          :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  authentication_token     :string(255)
#  role                     :string(255)      default("partner")
#  name                     :string(255)
#  sent                     :boolean          default(TRUE)
#  barcode                  :string(255)
#  barcode_data             :string(255)
#  barcode_img_file_name    :string(255)
#  barcode_img_content_type :string(255)
#  barcode_img_file_size    :bigint
#  barcode_img_updated_at   :datetime
#

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
