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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  verify_fixtures User
  # test "the truth" do
  #   assert true
  # end
  #

  test "should generate barcode" do
    u = User.new
    u.name = "Benoit"
    u.email = "benoit@test.com"
    u.password = "testtest"
    u.save!

    assert_not_nil u.barcode
    assert_not_nil u.barcode_data
  end
end
