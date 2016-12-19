# == Schema Information
#
# Table name: partners
#
#  id                       :integer          not null, primary key
#  email                    :string           default(""), not null
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :string
#  last_sign_in_ip          :string
#  authentication_token     :string
#  name                     :string
#  sent                     :boolean          default(TRUE)
#  barcode                  :string
#  barcode_data             :string
#  barcode_img_file_name    :string
#  barcode_img_content_type :string
#  barcode_img_file_size    :integer
#  barcode_img_updated_at   :datetime
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class Partner < ActiveRecord::Base
  include Barcodable

  default_scope { order "name ASC" }

  devise :trackable

  validates :name,  uniqueness: true, presence: true
  validates :email, uniqueness: true, format: Devise.email_regexp

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
