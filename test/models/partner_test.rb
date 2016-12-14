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

require 'test_helper'

class PartnerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
