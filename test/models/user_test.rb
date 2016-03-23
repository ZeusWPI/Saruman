# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  email                    :string           default(""), not null
#  encrypted_password       :string           default(""), not null
#  reset_password_token     :string
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :string
#  last_sign_in_ip          :string
#  created_at               :datetime
#  updated_at               :datetime
#  authentication_token     :string
#  role                     :string           default("partner")
#  name                     :string
#  sent                     :boolean          default(TRUE)
#  barcode                  :string
#  barcode_data             :string
#  barcode_img_file_name    :string
#  barcode_img_content_type :string
#  barcode_img_file_size    :integer
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
